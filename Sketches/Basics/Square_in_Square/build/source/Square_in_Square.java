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

public class Square_in_Square extends PApplet {
  public void setup() {

background(255);
//FirstSquare
stroke(0);
fill(0);
rect(0,0,100,100);

stroke(0);
fill(150);
rect(100,100,100,100);
    noLoop();
  }

  public void settings() { size(200,200); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Square_in_Square" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
