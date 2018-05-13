import SimpleOpenNI.*;

import processing.opengl.*;

SimpleOpenNI kinect;

void setup()
{

  size( 1024, 768, P3D);

  kinect = new SimpleOpenNI( this );

  kinect.enableDepth();

}

void draw()
{

  background( 0);

  kinect.update();
  image(kinect.depthImage(),0,0,160,120);//check depth image

  translate( width/2,  height/2, -1000);

  rotateX( radians(180));

  stroke(255);

  PVector[] depthPoints = kinect.depthMapRealWorld();

  //the program get stucked in the for loop it loops 307200 times and I don't have any points output

  for( int i = 0; i < depthPoints.length ; i+=4)//draw point for every 4th pixel
  {

    PVector currentPoint = depthPoints[i];
    if(i == 0) println(currentPoint);
    point(currentPoint.x,  currentPoint.y, currentPoint.z );
  }

}
