from skimage.metrics import mean_squared_error as mse
from skimage.metrics import structural_similarity as ssim
import cv2
import argparse

# -o: A path to the original image
# -c: A path to the comparison (copy or degraded) image
def options():
    parser = argparse.ArgumentParser(description="Read image metadata")
    parser.add_argument("-o", "--first", help="Input image file.", required=True)
    parser.add_argument("-c", "--second", help="Input image file.", required=True)
    args = parser.parse_args()
    return args

def main(): 
    args = options()

    image1 = cv2.imread(args.first)
    image2 = cv2.imread(args.second)

    # Convert the images to grayscale
    gray1 = cv2.cvtColor(image1, cv2.COLOR_BGR2GRAY)
    gray2 = cv2.cvtColor(image2, cv2.COLOR_BGR2GRAY)

    ho, wo, _ = image1.shape
    hc, wc, _ = image2.shape

    # compare ratio 
    if round(ho/wo, 2) != round(hc/wc, 2):
        print("\nImages not of the same dimension. Check input.")
        exit()
        
    elif ho > hc and wo > wc:
        print("\nResizing original image for analysis...")
        gray1 = cv2.resize(gray1, (wc, hc))

    elif ho < hc and wo < wc:
        print("\nResizing comparison image for analysis...")
        gray2 = cv2.resize(gray2, (wo, ho))

    print("MSE:", mse(gray1, gray2))
    print("SSIM:", ssim(gray1, gray2))

if __name__ == '__main__':
	main()

# MSE: The lower the error, the more "similar" the two images are.
# SSIM: The higher the value, the more "similar" the two images are.