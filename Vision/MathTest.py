import numpy as np
import math

center_img_y = 220
position_y = 80

ratio1 = 0.0135/20
ratio2 = 0.0135/24

#distance_to_button = 0.2840000092983246
distance_to_button = 0.323
distance_to_center = 0.304


# distance of the button in meters in relation to the camera position
center_button_diff = abs(center_img_y - position_y)* ratio1
#print("center_button_diff is: ",center_button_diff) 
button_Angle = math.acos((distance_to_button**2+center_button_diff**2-(distance_to_center**2))/(2*distance_to_button*center_button_diff))

camera_Angle = (math.pi/2)-button_Angle

ButtonCam_z_cooridnate = math.sin(camera_Angle) * distance_to_button
ButtonCam_x_cooridnate = math.sqrt(distance_to_button**2 + ButtonCam_z_cooridnate**2)

print("X: ", ButtonCam_x_cooridnate, "    Z: ", ButtonCam_z_cooridnate)


center_button_diff = abs(center_img_y - position_y)* ratio2
#print("center_button_diff is: ",center_button_diff)
button_Angle = math.acos((distance_to_button**2+center_button_diff**2-(distance_to_center**2))/(2*distance_to_button*center_button_diff))
print("Angle: ", button_Angle*180/math.pi)
camera_Angle = (math.pi/2)-button_Angle

ButtonCam_z_cooridnate = math.sin(camera_Angle) * distance_to_button
ButtonCam_x_cooridnate = math.sqrt(distance_to_button**2 + ButtonCam_z_cooridnate**2)

print("X: ", ButtonCam_x_cooridnate, "    Z: ", ButtonCam_z_cooridnate)

cosine_test = math.acos((0.12**2+0.323**2-(0.3**2))/(2*0.12*0.323))

print("New result: ", cosine_test*180/math.pi)