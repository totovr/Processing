import processing.serial.*;

Serial myPort;  // Create object from Serial class

//Serial variables
String val;     // Data received from the serial port
float a = 0;  

//Watch Variables
int s = second();
int m = minute();
int h = hour();
String t;

//Objects
PImage logo;
PFont title;

void setup() {
  size(1240,720);
  frameRate(1);
  //Open the port
  //String portName = Serial.list()[5]; //change the 0 to a 1 or 2 etc. to match your port
  //myPort = new Serial(this, portName, 38400);
  //print(myPort);
  //while (a < 5000) {         // cycle of 3 seconds duration, during this time
  //a = millis ();}            // you need to press the RESET buttom.
}

void draw() {
  
  watch();
  
}

void watch() {
  background(0);
  s = second();
  m = minute();
  h = hour();
  t = h + ":" + nf(m, 2) + ":" + nf(s, 2);
  //println(t);
  textSize(48);
  text (t, 20, 670);
}