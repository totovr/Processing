import SimpleOpenNI.*;
import processing.serial.*;

SimpleOpenNI kinect;
Serial myPort;

//Define two vectors to contain the position of the hand

PVector handVec = new PVector();
PVector mapHandVec = new PVector();
color handPointCol = color(255,0,0);

void setup(){
  kinect = new SimpleOpenNI(this);
  // enable mirror
  kinect.setMirror(true);
  // enable depthMap generation, hands and gestures
  kinect.enableDepth();
  
  //kinect.enableGesture();
  kinect.startGesture(SimpleOpenNI.GESTURE_HAND_RAISE);
  //kinect.enableHands();
  kinect.enableHand();
  // add focus gesture to initialise tracking
  //kinect.addGesture("RaiseHand");
  
    
  size(kinect.depthWidth(),kinect.depthHeight());
  String portName = Serial.list()[1]; // This gets the first port on your computer.
  myPort = new Serial(this, portName, 9600);
}

//Comenzar a reconozer gestos
void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition)
{
  kinect.endGesture(SimpleOpenNI.GESTURE_HAND_RAISE);
  kinect.startTrackingHand(endPosition);
}

//Trigger the creation of a Hand object
void onCreateHands(int handId, PVector pos, float time)
{
  handVec = pos;
  handPointCol = color(0, 255, 0);
}

//Update the data of the hand

void onUpdateHands(int handId, PVector pos, float time)
{
  handVec = pos;
}

void draw(){
  kinect.update();
  kinect.convertRealWorldToProjective(handVec,mapHandVec);
  //Print and draw the function 
  image(kinect.depthImage(), 0, 0);
  strokeWeight(10);
  stroke(handPointCol);
  point(mapHandVec.x, mapHandVec.y);
  
  //Start the communication 
  // Send a marker to indicate the beginning of the communication
  myPort.write('S');
  // Send the value of the mouse's x-position
  myPort.write(int(255*mapHandVec.x/width));
  // Send the value of the mouse's y-position
  myPort.write(int(255*mapHandVec.y/height));
  
}




