import cv2
import numpy as np
import pytesseract
import pyrealsense2 as rs
import math

import imutils
from matplotlib import pyplot as plt

import ctypes

# Number is camera index
# 0 => Integrated webcam, 1, 2, 3 => other connected cameras
cap = cv2.VideoCapture(2)


# Setup for image taking
# Setup:
pipe = rs.pipeline()
cfg = rs.config()
profile = pipe.start(cfg)



# Font stuff to write text on image
font                   = cv2.FONT_HERSHEY_SIMPLEX
fontScale              = 1
fontColor              = (0,255,255)
lineSize               = 3

def transform_button_pos(position_x, position_y, distance_to_button, distance_to_center, ratio, img_height, img_width):

    # finding the center of the image pixels
    center_img_x = img_width / 2
    center_img_y = img_height / 2

    # distance of the button in meters in relation to the camera position
    center_button_diff = (center_img_y - position_y)* ratio
    print("center_button_diff is: ",center_button_diff)
    button_Angle = math.acos((distance_to_button**2+center_button_diff**2-distance_to_center**2)/(2*distance_to_button*center_button_diff))

    camera_Angle = (math.pi/2)-button_Angle

    ButtonCam_z_cooridnate = math.sin(camera_Angle) * distance_to_button
    ButtonCam_x_cooridnate = math.sqrt(distance_to_button**2 + ButtonCam_z_cooridnate**2)
    
    #ButtonCam_x_cooridnate = math.sqrt(ButtonCam_z_cooridnate**2 + distance_to_button**2)
    #ButtonCam_y_coordinate = (center_img_x - position_x)* ratio
    print("button Angle", button_Angle)
    print("Camera Angle",camera_Angle)
    return (ButtonCam_x_cooridnate,ButtonCam_z_cooridnate)

def pixel_meter_conversion(button_r):

    real_button_radius = 0.014 # black button radius
    ratio = real_button_radius / button_r
    print("ratio is:", ratio)
    return ratio



def draw_circles(img_in, circles):
    for i in circles[0, :]:
        #print(i)
        # draw the outer circle
        cv2.circle(img_in, (i[0], i[1]), i[2], (0, 255, 0), 2)
        # draw the center of the circle
        cv2.circle(img_in, (i[0], i[1]), 2, (0, 0, 255), 3)

        cv2.putText(img_in, "x: " + str(i[0]) + " y: " + str(i[1]),
                    (i[0], i[1]),
                    font,
                    fontScale,
                    fontColor,
                    lineSize)

def find_draw_contours(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (5, 5), 0)
    edged = cv2.Canny(gray, 10, 50)
    #image2, cnts = cv2.findContours(edged.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
    #cnts = cnts[0] if imutils.is_cv2() else cnts[1]
    #cnts = sorted(cnts, key=cv2.contourArea, reverse=True)[:5]
    #screenCnt = None
    #for c in cnts:
    #    peri = cv2.arcLength(c, True)
    #    approx = cv2.approxPolyDP(c, 0.02 * peri, True)
    #    if len(approx) == 4:
    #        screenCnt = approx
    #        break

    #cv2.drawContours(image, [screenCnt], -1, (0, 255, 0), 2)
    cv2.imshow('canny image', edged)

    return edged

def recognize_text(img_in):
    config = ('-l eng --psm 12')

    # Run tesseract OCR on image
    text = pytesseract.image_to_string(img_in, config=config)

    return text

def find_circles(img_in):
    #img_in_copy = img_in

    img_in_gray = cv2.cvtColor(img_in, cv2.COLOR_BGR2GRAY)
    min_radius = 5#1 #5 #35
    max_radius = 100 #300 #100 #60
    min_dist_centers = 2*min_radius
    #cv2.imshow("grayscale",img_in_gray)
    circles = cv2.HoughCircles(img_in_gray, cv2.HOUGH_GRADIENT, 1, min_dist_centers, 
                                param1=40, param2=40, minRadius=min_radius, maxRadius=max_radius)

    if circles is None:
        print("NO CIRCLE FOUND - NO CIRCLE FOUND - NO CIRCLE FOUND - NO CIRCLE FOUND")
    else:
        circles = np.uint16(np.around(circles))
        for i in circles[0, :]:
            # draw the outer circle
            cv2.circle(img_in, (i[0], i[1]), i[2], (0, 255, 0), 2)
            # draw the center of the circle
            cv2.circle(img_in, (i[0], i[1]), 2, (0, 0, 255), 3)

            cv2.putText(img_in, "x: " + str(i[0]) + " y: " + str(i[1]),
                        (i[0], i[1]),
                        font,
                        fontScale,
                        fontColor,
                        lineSize)

    #print(circles[0, 1])

    
    #draw_circles(img_in, circles)
    print("all found circles:", circles)
    return circles

def get_button_img_pos(img_in, button_number):
    #Find circles in image
    circles = find_circles(img_in)
   # print('Found circles:', circles)

    # Circles are not sorted in order from top to bottom. Get the y values of button centers in ascending order
    sort_index = np.argsort(circles[0,:,1])
    #sort_index = np.argsort(circles)
    # Create new array of sorted button orders
    circles_sorted = []
    for i in sort_index:
        circles_sorted.append(circles[0,i])

    # Convert to numpy array and return the button called for.
    circles_return = np.array(circles_sorted)
    print('Sorted circles:',circles_return)

    return circles_return[button_number]

# Depth image taking function





def main():

    # Skip 5 first frames to give the Auto-Exposure time to adjust
    for x in range(5):
        pipe.wait_for_frames()

    # Store next frameset for later processing:
    frameset = pipe.wait_for_frames()
    #color_frame = frameset.get_color_frame()
    ret, frame = cap.read()
    # Taking RGB picture
    img = frame
    height, width, channels = frame.shape
    print("width is", width)
    print("height is",height)
    # Create alignment primitive with color as its target stream:
    align = rs.align(rs.stream.color)
    frameset = align.process(frameset)
    # Take DEPTH picture
    aligned_depth_frame = frameset.get_depth_frame()
    # Applying Decimation Filter
    colorizer = rs.colorizer()
    colorized_depth = np.asanyarray(colorizer.colorize(aligned_depth_frame).get_data())


    # Get button x, y position and radius in image. Param1 = image, Param3 = button number from top.

    button_x, button_y, button_r = get_button_img_pos(img, 0)#[0, 0]

    distance_to_button = aligned_depth_frame.get_distance(button_x,button_y)
    #distance_to_button = find_depth(aligned_depth_frame, button_x, button_y, button_r)
    print("distance to button: ", distance_to_button)
   # distance_to_center = find_depth(aligned_depth_frame, round(width/2), round(height/2), 1)
    distance_to_center = aligned_depth_frame.get_distance(round(width/2),round(height/2))
    print("distance to center:", distance_to_center)
    ratio_Pix_Meter = pixel_meter_conversion(button_r)
    button_pos = transform_button_pos(button_x, button_y, distance_to_button, distance_to_center, ratio_Pix_Meter, height, width)




    print('button position', button_pos)
   # print("button info: ", len(get_button_img_pos(img, 0)))
    print("xyr ", button_x, button_y, button_r)

    cv2.circle(img, (button_x, button_y), 3, (0, 0, 255), 3)



    cv2.imshow('original image', img)
    cv2.imshow('Depth',colorized_depth)

    key = cv2.waitKey(0)
    #cap.release()
    cv2.destroyAllWindows()



#if __name__ == "__main__":
main()





