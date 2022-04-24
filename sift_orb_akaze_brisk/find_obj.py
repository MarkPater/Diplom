#!/usr/bin/env python

'''
Feature-based image matching sample.

Note, that you will need the https://github.com/opencv/opencv_contrib repo for SIFT and SURF

USAGE
  find_obj.py [--feature=<sift|surf|orb|akaze|brisk>[-flann]] [ <image1> <image2> ]

  --feature  - Feature to use. Can be sift, surf, orb or brisk. Append '-flann'
               to feature name to use Flann-based matcher instead bruteforce.

  Press left mouse button on a feature point to see its matching point.
'''

# Python 2/3 compatibility
from __future__ import print_function

import sys
import numpy as np
import cv2 as cv

from common import anorm

def init_feature(feature):
    if feature == 'sift':
        detector = cv.SIFT_create()
        norm = cv.NORM_L2
    elif feature == 'surf':
        detector = cv.xfeatures2d.SURF_create(800)
        norm = cv.NORM_L2
    elif feature == 'orb':
        detector = cv.ORB_create(400)
        norm = cv.NORM_HAMMING
    elif feature == 'akaze':
        detector = cv.AKAZE_create()
        norm = cv.NORM_HAMMING
    elif feature == 'brisk':
        detector = cv.BRISK_create()
        norm = cv.NORM_HAMMING
    else:
        return None, None

    matcher = cv.BFMatcher(norm)
    return detector, matcher


def filter_matches(kp1, kp2, matches, ratio = 0.75):
    mkp1, mkp2 = [], []
    for m in matches:
        if len(m) == 2 and m[0].distance < m[1].distance * ratio:
            m = m[0]
            mkp1.append( kp1[m.queryIdx] )
            mkp2.append( kp2[m.trainIdx] )
    p1 = np.float32([kp.pt for kp in mkp1])
    p2 = np.float32([kp.pt for kp in mkp2])
    kp_pairs = zip(mkp1, mkp2)
    return p1, p2, list(kp_pairs)


def compare(feature, firstImageUrl, secondImageUrl):
    print(feature)
    print(firstImageUrl)
    print(secondImageUrl)
    img1 = cv.imread(cv.samples.findFile(firstImageUrl), cv.IMREAD_GRAYSCALE)
    img2 = cv.imread(cv.samples.findFile(secondImageUrl), cv.IMREAD_GRAYSCALE)
    detector, matcher = init_feature(feature)

    if img1 is None:
        print('Failed to load firstImageUrl:', firstImageUrl)
        sys.exit(1)

    if img2 is None:
        print('Failed to load secondImageUrl:', secondImageUrl)
        sys.exit(1)

    if detector is None:
        print('unknown feature:', feature)
        sys.exit(1)

    print('using', feature)

    kp1, desc1 = detector.detectAndCompute(img1, None)
    kp2, desc2 = detector.detectAndCompute(img2, None)
    print('img1 - %d features, img2 - %d features' % (len(kp1), len(kp2)))

    print('matching...')
    raw_matches = matcher.knnMatch(desc1, trainDescriptors = desc2, k = 2) #2
    p1, p2, kp_pairs = filter_matches(kp1, kp2, raw_matches)
    if len(p1) >= 4:
        H, status = cv.findHomography(p1, p2, cv.RANSAC, 5.0)
        inliers = int(np.sum(status))
        matched = len(status)
        print('%d / %d  inliers/matched' % (inliers, matched))
        return [len(kp1), len(kp2), inliers, matched, "{:.2f}%".format(inliers * 100 / matched)]
    else:
        H, status = None, None
        print('%d matches found, not enough for homography estimation' % len(p1))
        return [len(kp1), len(kp2), len(p1), 0, 0]