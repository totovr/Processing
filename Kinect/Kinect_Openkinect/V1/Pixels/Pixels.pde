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
  
  //skip 20 pixels
  int skip = 20;
  for (int x = 0; x < img.width; x+= skip){
    for (int y = 0; y < img.height; y+= skip){
      int index = x + y * img.width;
      float b = brightness(img.pixels[index]);
      
      fill(b);
      rect(x,y,skip,skip);
    }
  }
}