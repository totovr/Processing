import processing.opengl.*;
import SimpleOpenNI.*;
import kinectOrbit.*;

KinectOrbit myOrbit;
SimpleOpenNI kinect;

void setup()
{
  size(800, 600, OPENGL);
  myOrbit = new KinectOrbit(this, 0);
  kinect = new SimpleOpenNI(this);
  // enable depthMap generation
  kinect.enableDepth();
}

void draw()
{
  kinect.update();
  background(0);
  myOrbit.pushOrbit(this);
  drawPointCloud();
  // draw the kinect cam and frustum
  kinect.drawCamFrustum();
  myOrbit.popOrbit(this);
}

void drawPointCloud() 
{
// draw the 3d point depth map
  for (int i=0; i<kinect.depthMapRealWorld().length;i+=3)
  {
    stroke(255);
    point(kinect.depthMapRealWorld()[i].x, kinect.depthMapRealWorld()[i].y,
    kinect.depthMapRealWorld()[i].z);
  }
}
