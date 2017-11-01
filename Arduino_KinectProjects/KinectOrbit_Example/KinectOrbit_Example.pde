import processing.opengl.*;
import kinectOrbit.*;
KinectOrbit myOrbit;

void setup()
{
  size(800, 600, OPENGL);
  myOrbit = new KinectOrbit(this);
}

void draw()
{
  background(255);
  myOrbit.pushOrbit(this);
  box(500);
  myOrbit.popOrbit(this);
  rect(10,10,50,50);
}
