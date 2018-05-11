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

public class gravity extends PApplet {

// Simple gravity

Ball ball1;
Ball ball2;

public void setup() {
    
    ball1 = new Ball(100, 0, 0, 0.3f);
    ball2 = new Ball(300, 0, 0, 0.1f);
}
public void draw() {
    background(100);
    ball1.display();
    ball1.move();
    ball2.display();
    ball2.move();
}
class Ball {

  // x location
  float x;
  // y location
  float y;
  // speed
  float speed;
  // gravity
  float w;

  Ball(float Tempx, float Tempy, float Tempspeed, float Tempw) {
    x = Tempx;
    y = Tempy;
    speed = Tempspeed;
    w = Tempw;
  }

  public void display () {
    // display the square
    fill(255);
    noStroke();
    ellipseMode(CENTER);
    ellipse(x,y,10,10);
  }

  public void move() {
    // Add speed to y location
    y = y + speed;
    // Add gravity to speed
    speed = speed + w;
    // If square reaches the bottom
    // Reverse speed
    if (y > height) {
    speed = speed * -0.95f;
    }
  }
}
  public void settings() {  size(400,400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "gravity" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
