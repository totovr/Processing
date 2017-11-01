import processing.opengl.*;
void setup()
{
size(800, 600, OPENGL);
}
void draw()
{
  background(255);
  noFill();
  
  pushMatrix();
  translate(mouseX,mouseY);
  rotate(80);
  box(200);
  
  translate(300,0);
  box(50);
  popMatrix();
  
  translate(200,200);
  box(100);
}
