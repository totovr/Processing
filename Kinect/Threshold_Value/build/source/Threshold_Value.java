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

public class Threshold_Value extends PApplet {


SimpleOpenNI kinect;

PImage depthCam;
PImage result;

public void setup() {

        // make the sketch size a that of kinect sample
        
        // set a background color
        background(0);
        // instantatiate the SimpleOpenNI object
        //paremeter : is the current context
        kinect  = new SimpleOpenNI(this);
        //put this in setup so that we can tell the lib in advance what type of data we want

        //invoke the method from the lib to allow access to the depth camera
        kinect.enableDepth();

        // create an empty PImage container
        result = createImage(640, 480, RGB);
}

public void draw() {
        //reset the background
        background(0);
        // get the next frame from the kinect
        kinect.update();
        // get the depth image and assign to the PImage var (using the lib)
        depthCam = kinect.depthImage();

        //Draw the depthCam image
        image(depthCam, 640, 0);

        // get the depthMap (mm) values
        int[] depthVals = kinect.depthMap();

        // load the pixel array of the result image
        result.loadPixels();

        //go through the matrix - for each row go through every column
        for (int y=0; y<depthCam.height; y++)
        {
                //go through each col
                for (int x =0; x<depthCam.width; x++)
                {
                        // get the location in the depthVals array
                        int loc = x+(y*depthCam.width);
                        // if the depth values of the sampled image are in range
                        if (depthVals[loc] > 610 && depthVals[loc]< 900 )
                        {
                                //let the pixel value in the result image be white
                                result.pixels[loc] = color(0xfff1877c);
                        }
                        else {
                          //otherwise let the pixel value in the result image be white
                          result.pixels[loc] = color(0xff000000);
                        }
                }
        }
        // update
        result.updatePixels();
        //display the result
        image(result, 0, 0);
}
  public void settings() {  size(1280, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Threshold_Value" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
