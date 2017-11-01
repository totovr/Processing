import processing.opengl.*;
void setup()
{
size(800, 600, OPENGL);
}
void draw()
{
background(255);
noFill();
translate(mouseX,mouseY);
rotate(180);
box(200);
}

