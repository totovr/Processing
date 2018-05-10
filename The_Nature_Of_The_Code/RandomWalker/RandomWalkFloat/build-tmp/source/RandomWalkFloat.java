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

public class RandomWalkFloat extends PApplet {

Walker w;

public void setup() {
  
  w = new Walker();
  background(255);
}

public void draw() {
  w.display();
  w.step();
}
class Walker {
  int x;
  int y;

  Walker() {
    x = width/2;
    y = height/2;
  }

  public void display() {
    stroke(0);
    point(x,y);
  }

  public void step() {
    float stepx = random(-1, 1);
    float stepy = random(-1, 1);
    x += stepx;
    y += stepy;
  }
}
  public void settings() {  size(640, 360); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RandomWalkFloat" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
