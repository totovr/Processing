import processing.opengl.*; 
import SimpleOpenNI.*; 
SimpleOpenNI kinect; 
float rotation = 0; 
int boxSize = 150; 
int frameSkip = 5; //increase this to get better framerate 

PVector boxCenter = new PVector(0, 0, 600); 
// this will be used for zooming 
float s = 1; 

void setup() { 
  size(1024, 768, OPENGL); 
  kinect = new SimpleOpenNI(this); 
  kinect.enableDepth(); 
} 

void draw() { 
  background(0); 
  kinect.update(); 
  translate(width/2, height/2, -1000); 
  rotateX(radians(180)); 
  translate(0, 0, 1400); 
  rotateY(radians(map(mouseX, 0, width, -180, 180))); 

  translate(0,0,s*-1000); 
  scale(s); 
  println(s); 
  stroke(255); 
  PVector[] depthPoints = kinect.depthMapRealWorld(); 
  for (int i = 0; i < depthPoints.length; i+=frameSkip) 
  { 
    PVector currentPoint = depthPoints[i]; 
    point(currentPoint.x, currentPoint.y, currentPoint.z); 
  } 
} 
// use keys to control zoom 
// up-arrow zooms in 
// down arrow zooms out 
// s gets passed to scale() in draw() 
void keyPressed(){ 
  if(keyCode == 38){ 
    s = s + 0.01; 
  } 

  if(keyCode == 40){ 
   s = s - 0.01; 
  } 
} 

void mousePressed(){ 
  save("touchedPoint.png"); 
} 
