PWindow win;
PImage img;

float beginX = 20.0;  // Initial x-coordinate
float beginY = 10.0;  // Initial y-coordinate
float endX = 570.0;   // Final x-coordinate
float endY = 320.0;   // Final y-coordinate
float distX;          // X-axis distance to move
float distY;          // Y-axis distance to move
float exponent = 4;   // Determines the curve
float x = 0.0;        // Current x-coordinate
float y = 0.0;        // Current y-coordinate
float step = 0.01;    // Size of each step along the path
float pct = 0.0;      // Percentage traveled (0.0 to 1.0)


public void settings() { //void setting is used when you are working outside of the PDE
  size(800, 450);
}

void setup() { 
  win = new PWindow();
  img = loadImage("flor.jpg");
  noStroke();
  distX = endX - beginX;
  distY = endY - beginY;
}

void draw() {
  background(img);
  //rect(10, 10, frameCount, 10);
  recta();
}

void mousePressed() {
 
  pct = 0.0;
  beginX = x;
  beginY = y;
  endX = mouseX;
  endY = mouseY;
  distX = endX - beginX;
  distY = endY - beginY;
}  

void recta(){

  fill(0, 2);
  rect(0, 0, width, height);
  pct += step;
  if (pct < 1.0) {
    x = beginX + (pct * distX);
    y = beginY + (pow(pct, exponent) * distY);
  }
  fill(255);
  ellipse(x, y, 20, 20);

}