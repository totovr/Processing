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

public class RandomWalkMouse extends PApplet {

Walker w;

public void setup() {
  
  w = new Walker();
  background(255);

}

public void draw() {
  w.display();
  w.step(mouseX, mouseY);
}
class Walker {

float x;
float y;

float xPos;
float yPos;

Walker() {
  x = width/2;
  y = height/2;
}

public void display() {
        stroke(0);
        point(xPos,yPos);
}

public void step(float xTemp, float yTemp) {
  xPos = xTemp;
  yPos = yTemp;
        //generate a value between 0 and 1
        float r = random(1);
        if(r < 0.5f) {
                xPos++;
                yPos++;
        } else {
                xPos--;
                yPos--;
        }
}
}
  public void settings() {  size(640, 360); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RandomWalkMouse" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
