import org.openkinect.processing.*;

Kinect kinect;

void setup() {
 size(512,424);
 kinect = new Kinect(this); 
 kinect.initDepth();
}

void draw(){
background(0);
//Save the depth data extrated from the camera in img
PImage img = kinect.getDepthImage();
image(img,0,0);
  
}