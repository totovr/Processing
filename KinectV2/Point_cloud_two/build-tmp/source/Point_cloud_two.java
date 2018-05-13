import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Point_cloud_two extends PApplet {

//import processing.opengl.*; 
 

SimpleOpenNI kinect; 

float rotation = 0; 
int boxSize = 150; 
int frameSkip = 5; //increase this to get better framerate 

PVector boxCenter = new PVector(0, 0, 600); 
// this will be used for zooming 
float s = 1; 

public void setup() { 
   
  kinect = new SimpleOpenNI(this); 
  kinect.enableDepth(); 
} 

public void draw() { 
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
public void keyPressed(){ 
  if(keyCode == 38){ 
    s = s + 0.01f; 
  } 

  if(keyCode == 40){ 
   s = s - 0.01f; 
  } 
} 

public void mousePressed(){ 
  save("touchedPoint.png"); 
} 
  public void settings() {  size(1024, 768, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Point_cloud_two" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
