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

public class Alpha extends PApplet {
  public void setup() {

background(0);
noStroke( );

//The alpha (las value) is the opacity of the color

fill(0,0,255);
rect(0,0,250,500);

fill(255,0,0,255);
rect(0,0,500,80);

fill(255,0,0,127);
rect(0,210,500,80);

fill(255,0,0,63);
rect(0,420,500,80);
    noLoop();
  }

  public void settings() { size(500,500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Alpha" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
