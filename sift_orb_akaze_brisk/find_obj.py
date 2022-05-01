import sys
import numpy as np
import cv2 as cv


def create_detector(detector):
    if detector == 'sift':
        return cv.SIFT_create()
    elif detector == 'orb':
        return cv.ORB_create(10000)
    elif detector == 'akaze':
        return cv.AKAZE_create()
    elif detector == 'brisk':
        return cv.BRISK_create()
    return None


# By default, it is cv.NORM_L2. It is good for SIFT, SURF etc (cv.NORM_L1 is also there).
# For binary string based descriptors like ORB, BRIEF, BRISK etc,
# cv.NORM_HAMMING should be used, which used Hamming distance as measurement.
def create_matcher(detector):
    if detector == 'sift':
        return cv.BFMatcher(cv.NORM_L2)
    return cv.BFMatcher(cv.NORM_HAMMING)


def check_errors(img1, img2, detector):
    if img1 is None:
        print('Error: failed to load first image')
        sys.exit(1)
    if img2 is None:
        print('Error: failed to load second image')
        sys.exit(1)
    if detector is None:
        print('Error: failed to create detector')
        sys.exit(1)


# Apply ratio test explained by D.Lowe in his paper
def filter_matches(kp1, kp2, matches, ratio = 0.75):
    mkp1, mkp2 = [], []
    for m in matches:
        if len(m) == 2 and m[0].distance < m[1].distance * ratio:
            best_m = m[0]
            mkp1.append( kp1[best_m.queryIdx] )
            mkp2.append( kp2[best_m.trainIdx] )
    p1 = np.float32([kp.pt for kp in mkp1])
    p2 = np.float32([kp.pt for kp in mkp2])
    return p1, p2


def compare(detector_type, first_image_url, second_image_url):
    img1 = cv.imread(first_image_url, cv.IMREAD_GRAYSCALE)
    img2 = cv.imread(second_image_url, cv.IMREAD_GRAYSCALE)
    detector = create_detector(detector_type)
    matcher = create_matcher(detector_type)

    check_errors(img1, img2, detector)

    features1, descriptors1 = detector.detectAndCompute(img1, None)
    features2, descriptors2 = detector.detectAndCompute(img2, None)
    raw_matches = matcher.knnMatch(descriptors1, descriptors2, k = 2)
    matched_features1, matched_features2 = filter_matches(features1, features2, raw_matches)

    # It needs atleast 4 correct points to find the transformation.
    if len(matched_features1) >= 4:
        _, status = cv.findHomography(matched_features1, matched_features2, cv.RANSAC, 5.0)
        inliers = int(np.sum(status))
        matched = len(status)
        return [len(features1), len(features2), inliers, matched, "{:.2f}%".format(inliers * 100 / matched)]
    else:
        return [len(features1), len(features2), len(matched_features1), 0, 0]