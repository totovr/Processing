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

public class GrayScale extends PApplet {

PImage img1, img2;

public void setup() {
  img1 = loadImage("yo.jpg");
  img2 = loadImage("yo.jpg");
  img2.filter(GRAY);
}

public void draw() {
  image(img1, 0, 0);
  image(img2, width/2, 0);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GrayScale" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
