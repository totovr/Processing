import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Image_Cam extends PApplet {



//Class
Webcam webc;

PImage img;

public void settings() { //void setting is used when you are working outside of the PDE
  size(800, 450);
}

public void setup() {
  webc = new Webcam();
  img = loadImage("flor.jpg");

}

public void draw() {
  background(img);
}
  class Webcam extends PApplet {
    Webcam() {
      super();
      PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
    }

  Capture cam;
  
  public void settings() {
    size(1280,960);
  }

  public void setup() {String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {

      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
      }
    // The camera can be initialized directly using an
    // element from the array returned by list():
    cam = new Capture(this, cameras[1]);
    cam.start();

    }
  }

  public void draw() {

    if (cam.available() == true) {
    cam.read();
    }
    image(cam, 0, 0);
  }


}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Image_Cam" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
