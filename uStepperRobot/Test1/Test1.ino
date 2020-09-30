#include <uStepperS.h>

uStepperS stepper;
float angle = 100.0;
bool moveState = false;

float gearRatio = 5.1;


void setup() {
  // put your setup code here, to run once:
  stepper.setup();
  stepper.setMaxAcceleration(2000);
  stepper.setMaxVelocity(500);
  Serial.begin(9600);
  
}

void loop() {
  // put your main code here, to run repeatedly:

  /*
  if(!stepper.getMotorState() && moveState == false)
  {
    delay(1000);
    stepper.moveAngle(angle);
    angle = -angle;
    moveState = true;
  }
  */
   
   Serial.print("Angle: ");
   Serial.print(stepper.encoder.getAngleMoved());

   Serial.print("           ");
   
   Serial.print("Angle Joint: ");
   Serial.print(stepper.encoder.getAngleMoved()/gearRatio);
   //Serial.print(stepper.getMotorState());
   Serial.println(" Degrees");
}
