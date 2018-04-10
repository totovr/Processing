import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class car extends PApplet {

int globalX = 0;
int globalY = 100;
int speed = 1;

public void setup() {
  
}

public void draw() {
  background(255);
  move();
  bounce();
  drawCar(globalX, globalY, 24, color(100));
}

public void move() {
  // Change the x location by speed
  globalX = globalX + speed;
}

public void bounce() {
  if ((globalX > width) || (globalX < 0)) {
    speed = speed * -1;
  }
}

public void drawCar(int x, int y, int thesize, int c) {
  int offset = thesize / 4;
  rectMode(CENTER);
  stroke(0);
  fill(c);
  rect(x, y, thesize, thesize/2);
  fill(200);
  rect(x - offset, y - offset, offset, offset/2);
  rect(x + offset, y - offset, offset, offset/2);
  rect(x - offset, y + offset, offset, offset/2);
  rect(x + offset, y + offset, offset, offset/2);
}
  public void settings() {  size(200, 200); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "car" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
