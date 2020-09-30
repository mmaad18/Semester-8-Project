#include <Wire.h>
#include <math.h>

bool sendState = false;

const byte numChars = 32;
char receivedChars[numChars];   // an array to store the received data

boolean newData = false;

float joint1offset = 32.94-90; //Degrees. -57.06 for zero position 
float joint2offset = 180-46.1; //Degrees.  133.9 for zero position

float j1Angle;
float j2Angle;


void setup() {
  Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600);
}

void loop() {

    //Listen on the serial port for new data
    recvWithEndMarker();
    String reqRecv1;
    String reqRecv3;
    
    Wire.requestFrom(1, 4); // Request 4 bytes (float) from device 1. (Joint 1)
    while (Wire.available()) {
      reqRecv1 += (char)Wire.read();
    }

    Wire.requestFrom(3, 4); // Request 4 bytes (float) from device 1. (Joint 1)
    while (Wire.available()) {
      reqRecv3 += (char)Wire.read();
    }

    Serial.print("Joint1Feedback:  ");
    Serial.print(reqRecv1.toFloat());

    Serial.print("     Joint2Feedback:  ");
    Serial.print(reqRecv3.toFloat());

    Serial.print("     Timestamp:   ");
    Serial.println(millis());

    

    // If new data is received enter this if statement.
    if (newData == true) {

      // Convert bytes received on the serial port to string
      String serData(receivedChars);

      //Get X and Z coordinates received on the serial port
      float xCord = getXcoordinate(serData);
      float zCord = getZcoordinate(serData);
      
      //Serial.print("X Coordinate:  ");
      //Serial.println(xCord);
      
      //Serial.print("Z Coordinate:  ");
      //Serial.println(zCord);

      j1Angle = xCord;
      j2Angle = zCord;

      // Do inverse kinematics and calculate joint angles based on X and Z coordinates
      // This function will update the j1Angle and j2Angle global variables. 
      

      //calculateJointAngles(xCord,zCord);
      Serial.print("Joint1Set:  ");
      //Serial.print(joint1offset-j1Angle);
      Serial.print(j1Angle);

      Serial.print("     Joint2Set:  ");
      //Serial.print((j2Angle-joint2offset)+(j1Angle-joint1offset));
      Serial.print(j2Angle);

      Serial.print("     Timestamp:   ");
      Serial.println(millis());

      //Serial.println(" ");

      // Convert the joint angles into steps to send to the motors
      // String motor1Steps(getMotor1Rotation(j1Angle));
      // String motor2Steps(getMotor2Rotation(j1Angle, j2Angle));

      String motor1Steps(j1Angle);
      String motor2Steps(j2Angle);

      // Check if joint angles will reach any physical joint limits
      //if (jointLimitsReached(j1Angle, j2Angle) == false) {

        // If no joint limits reached, send steps to motor 1 over I2C with I2C address 1
        Wire.beginTransmission(1); // transmit to device #1
        Wire.write(motor1Steps.c_str());  // sends 4 bytes
        Wire.endTransmission();    // stop transmitting

        // Send steps to motor 2 over I2C with address 3
        Wire.beginTransmission(3); // transmit to device #3
        Wire.write(motor2Steps.c_str());  // sends 4 bytes
        Wire.endTransmission();    // stop transmitting
      /*}

      else {
        // Only goes here if the point is making it reach the joint limits.
        Serial.println("Limits reached!");
      }*/
          
      newData = false;

      //delay(10);
      
    }
  
}


/*
 * Function to receive new data over serial port. Updates the global char array receivedChars.
*/
void recvWithEndMarker() {
    static byte ndx = 0;
    char endMarker = '\n';
    char rc;
    
    if (Serial.available() > 0) {
        rc = Serial.read();

        if (rc != endMarker) {
            receivedChars[ndx] = rc;
            ndx++;
            if (ndx >= numChars) {
                ndx = numChars - 1;
            }
        }
        else {
            receivedChars[ndx] = '\0'; // terminate the string
            ndx = 0;
            newData = true;
        }
    }
}


/*
 * Gets the X coordinate from the string received on the serial port.
 */
float getXcoordinate(String serialData) {
  bool xState = true;
  String xCord = "";
  int charCounter = 1;

  // Gets alle the values after "X" in the string and until "Z".
  while (xState == true) {
    if (serialData[charCounter] != 'Z' && serialData[charCounter] != 'z' && serialData[charCounter] != '\0') {
      xCord += serialData[charCounter];
      charCounter++;
    }
    else {
      xState = false;
      break;
    }
    
  }

  //return X coordinate converted to a float.
  return xCord.toFloat();
}


/*
 * Gets the Z coordinate from the string received on the serial port.
 */
float getZcoordinate(String serialData) {
  bool zState = true;
  String zCord = "";
  int charCounter = 1;

  //Finds the index in the string where Z is.
  for (int i = 0; i < serialData.length(); i++) {
    if (serialData[i] == 'Z' || serialData[i] == 'z') {
      charCounter = i + 1;
      break;
    }
  }

  // Get all the values after the Z index in the string in a new string "zCord".
  while (zState == true) {
    
    if (serialData[charCounter] != '\0') {
      zCord += serialData[charCounter];
      charCounter++;
    }
    
    else {
      zState = false;
      break;
    }
    
  }

  // Return the Z value converted to a float.
  return zCord.toFloat();
}



/*
 * Get the rotation of motor 1 based on the calculated joint angle for joint 1.
 */
float getMotor1Rotation(float joint1Angle) {
  
  return (joint1Angle-joint1offset)*-1;
  
}


/*
 * Get the rotation of motor 2 based on the calculated joint angle for joint 1 and joint 2.
 */
float getMotor2Rotation(float joint1Angle, float joint2Angle) {
  
  return (joint2Angle-joint2offset)+(joint1Angle-joint1offset);
  
}

/*
 * THIS IS WORKING - BLACKBOARD DANIEL/MARTIN
 */

/*
void calculateJointAngles(float x, float z) {
  float L1 = 18.2;
  float L2 = 18.74; // calculated and verified by measurement. From one rotating joint to the other.

  j1Angle = rad2deg(asin(x/(sqrt(pow(x,2)+pow(z,2))))) - rad2deg(acos((pow(L1,2) + (pow(x,2) + pow(z,2)) - pow(L2,2))/(2*L1*sqrt(pow(x,2) + pow(z,2)))));
  j2Angle = 180 - rad2deg(acos((pow(L1,2) + pow(L2, 2) - (pow(x,2) + pow(z,2)))/(2*L1*L2)));
}
*/

/*
 * MOHAMEDS MATLAB SOLVED STUFF- WORKS VERY WELL
 */

 /*
void calculateJointAngles(float x, float z) {
  float L1 = 18.2;
  float L2 = 18.74; // calculated and verified by measurement. From one rotating joint to the other.

  j1Angle = rad2deg(2*atan((2*L1*x + (pow(L1, 2)*sqrt((- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2))*(pow(L1, 2) + 2*L1*L2 + pow(L2, 2) - pow(x, 2) - pow(z, 2))))/(- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2)) + (pow(L2, 2)*sqrt((- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2))*(pow(L1, 2) + 2*L1*L2 + pow(L2, 2) - pow(x, 2) - pow(z, 2))))/(- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2)) - (pow(x, 2)*sqrt((- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2))*(pow(L1, 2) + 2*L1*L2 + pow(L2, 2) - pow(x, 2) - pow(z, 2))))/(- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2)) - (pow(z, 2)*sqrt((- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2))*(pow(L1, 2) + 2*L1*L2 + pow(L2, 2) - pow(x, 2) - pow(z, 2))))/(- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2)) - (2*L1*L2*sqrt((- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2))*(pow(L1, 2) + 2*L1*L2 + pow(L2, 2) - pow(x, 2) - pow(z, 2))))/(- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2)))/(pow(L1, 2) + 2*L1*z - pow(L2, 2) + pow(x, 2) + pow(z, 2))));
  j2Angle = rad2deg(2*atan(sqrt((- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2))*(pow(L1, 2) + 2*L1*L2 + pow(L2, 2) - pow(x, 2) - pow(z, 2)))/(- pow(L1, 2) + 2*L1*L2 - pow(L2, 2) + pow(x, 2) + pow(z, 2))));
}
*/

/* 
 *  THIS IS THE INVERSE KINEMATICS FROM THE REPORT. Works. (Chris' work)
 */
 
   
void calculateJointAngles(float x, float z) {
  float L1 = 18.2;
  float L2 = 18.74; // calculated and verified by measurement. From one rotating joint to the other.
  
  
  float D = (pow(L1,2) + pow(L2, 2) - (pow(x,2) + pow(z, 2)))/(2*L1*L2);
  float j2 =  M_PI - atan2(-sqrt(1-pow(D, 2)),D);
  
  float alpha = atan2(L2*sin(j2),L1 + L2*cos(j2));
  
  float beta = atan2(z,x);

  float j1 = beta - alpha;

  j1Angle = 90 - rad2deg(j1);
  j2Angle = 360 - rad2deg(j2);
}



/*
 *  Converts radians to degrees
 */
float rad2deg(float rad) {
  //float deg = (rad * 4068.0) / 71;
  float deg = (rad * 180)/PI;
  return deg; 
}


/*
 *  Converts degrees to radians
 */
float deg2rad(float deg) {
  //float rad = (deg * 71) / 4068.0;
  float rad = (deg*PI)/180;
  return rad;
}


/*
 *  Function returning true if any of the robots physical limits is going to be violated given the calculated
 *  joint angles. Returns false if all's good.
 */
bool jointLimitsReached(float joint1Angle, float joint2Angle) {

  // true if joint 2 wants to go further up than physically possible
  if (joint2Angle < 90-joint1Angle) {
    return true;
  }

  // true if joint 2 wants to go further down than physically possible
  else if (joint2Angle > joint2offset) {
    return true;
  }

  // true if joint 1 wants to go further back than the physical limits of the second joint allows
  else if (joint1Angle < joint1offset) {
    return true;
  }

  // true if joint 1 wants to go further than 100° in the clockwise direction.
  else if (joint1Angle > 100.0) {
    return true;
  }

  else {
    return false;
  }
  
}
