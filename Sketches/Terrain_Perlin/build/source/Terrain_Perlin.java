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

public class Terrain_Perlin extends PApplet {

int cols, rows;
int scl = 20;
int w = 2000;
int h = 1600;

float flying = 0;

float[][] terrain;

public void setup(){

  
  //Columns and rows size
  cols = w/scl;
  rows = h/scl;
  terrain = new float[cols][rows];
  float yoff = 0;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff,yoff), 0, 1, -100, 100);
      xoff += 0.2f;
    }
    yoff += 0.2f;
  }
}

public void draw(){

  flying -= 0.1f;
  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff,yoff), 0, 1, -100, 100);
      xoff += 0.2f;
    }
    yoff += 0.2f;
  }

  background(0);
  stroke(255);
  noFill();

  translate(width/2, height/2+50);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for (int y = 0; y < rows - 1; y++) {
    //beginShape(TRIANGLE_STRIP);
    beginShape(QUADS);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl,y*scl, terrain[x][y]);
      vertex(x*scl,(y+1)*scl, terrain[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
  //Activate to save video
  //saveFrame("output/line-######.png");
}
  public void settings() {  size(600, 600, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Terrain_Perlin" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
