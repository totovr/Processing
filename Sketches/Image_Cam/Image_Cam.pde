import processing.video.*;

//Class
Webcam webc;
PImage img;

public void settings() { //void setting is used when you are working outside of the PDE
  size(800, 450);
}

void setup() {
  webc = new Webcam();
  img = loadImage("flor.jpg");

}

void draw() {
  background(img);
}
