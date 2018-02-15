#include <Arduino.h>
//#include <SimpleTimer.h>

const int Laser_WeaponIn = 2;//pin for pullup resistor D2
int laser_value = 0;
int last_laser_value = 0;// previous state of the button
int led = 3;

//Declare the functions
void Laser_Weapon();

//Objects
//SimpleTimer Player_One;//Don't write "timer" as and object

void setup() {
        //We will use this to send the data to Processing
        Serial.begin(115200);
        //Timer readings
        //Player_One.setInterval(5000, ArduinoM1_Processing);//repeats every 20 msecond
}

void loop() {
        //Player_One.run();
        //Player_Two.run();
        Laser_Weapon();
}

void Laser_Weapon() {
        laser_value = digitalRead(Laser_WeaponIn);
        if (laser_value != last_laser_value) {
                if (laser_value == LOW) {
                        digitalWrite(led, HIGH);
                        Serial.write(100);
                        delay(5000);
                        Serial.write(0);
                } else {
                  digitalWrite(led, LOW);
                }
        }
        Serial.write(0);
        delay(100);
        last_laser_value = laser_value;        //Evaluate the last state of the push buttom
}
