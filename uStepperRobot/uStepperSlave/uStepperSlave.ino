#include <uStepperS.h>
#include <Wire.h>

uStepperS stepper;
bool moveState = false;

float gearRatio = 5.1;

String data = "";


union floatToBytes {
  char buffer[4];
  float jointAngle;
} converter;



void setup() {
  Wire.begin(1);                // join i2c bus with address #8
  Wire.onReceive(receiveEvent); // register event
  Wire.onRequest(requestEvent);
  stepper.setup();
  stepper.setMaxAcceleration(2000);
  stepper.setMaxVelocity(500);
  Serial.begin(9600);           // start serial for output

  Serial.print("Position is:  ");
  Serial.println(stepper.encoder.getAngleMoved());
}

void loop() {
  delay(100);
  //Serial.println("Nothing received i guess");
  
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany) {
  data = "";
  while(Wire.available()) {
    data += (char)Wire.read();
  }

  

  //Serial.println(data.toFloat());
  /*
  while (1 < Wire.available()) { // loop through all but the last
    char c = Wire.read(); // receive byte as a character
    Serial.print(c);         // print the character
  }*/
  
  int angleRec = data.toFloat();    // receive byte as an integer
  Serial.println(angleRec);         // print the float
  Serial.print("Position is:  ");
  Serial.println(stepper.encoder.getAngleMoved()/gearRatio);
  Serial.print("Move to position:  ");
  Serial.println(angleRec);

  if(!stepper.getMotorState())
  { 
    delay(10);
    stepper.moveToAngle(angleRec*gearRatio);
  }
  
}



// function that executes whenever data is requested by master
// this function is registered as an event, see setup()
void requestEvent() {
  
  String jointMoved(stepper.encoder.getAngleMoved()/gearRatio);
  
  
  Wire.write(jointMoved.c_str()); // respond with message of 4 bytes as expected by master
  //Wire.write("\n");
}
