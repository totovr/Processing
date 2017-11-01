import processing.opengl.*;
import kinectOrbit.*;

KinectOrbit kOrbit;

void setup() {

  size(800, 600, OPENGL);
  smooth();
  //Set the file number and the scale
  // We can also iniyialize as  kOrbit = new KinectOrbit(this); 
  kOrbit = new KinectOrbit(this, 0, "kinect"); 
  kOrbit.drawGizmo(true); // This controls the gizmo on screen
  kOrbit.shiftControl(true); // Orbit only when shift is pressed
}

void draw() {

  background(0);

  kOrbit.pushOrbit(this); // Start Orbiting

  box(50);

  kOrbit.popOrbit(this); // End Orbiting
}

