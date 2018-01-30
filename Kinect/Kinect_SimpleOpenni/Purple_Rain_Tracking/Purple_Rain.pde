import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

PImage userImage;
int userID;
int[] userMap;
PImage depthImage;

Drop [] drops = new Drop[500];

void setup() {
  size(640, 480);
  for (int i = 0; i < drops.length; i++) {
  drops [i] = new Drop();
  }
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(); 
}

void draw() {
  background(230, 230, 250);
  for (int i = 0; i < drops.length; i++) {
  drops[i].fall(); 
  drops[i].show();
  }
  Kinecto();
  saveFrame("Output/rain-######.png");
}

void Kinecto() {  
  kinect.update();  
  depthImage = kinect.depthImage();
  // prepare the Depth pixels 
  depthImage.loadPixels();
  // if we have detected any users
  if(kinect.getNumberOfUsers() > 0) {  
    // find out which pixels have users in them
    userMap =kinect.userMap();  
    // populate the pixels array
    // from the sketch's current contents
    loadPixels();  
    for (int i = 0; i < userMap.length; i++) {  
      // if the current pixel is on a user
      if (userMap[i] != 0) {
      //pixels[i] = depthImage.pixels[i];
      // make it green
      pixels[i] = color(204, 39, 242);  
      }
    }
     // display the changed pixel array
     updatePixels();  
  }
}