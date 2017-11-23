//Size of the window
size(200,200);
//Draw the back ground
background(90,146,203,79);
//enable anti-aliasing
smooth();

//Draw the head
rectMode(CENTER);  // Set rectMode to CENTER
fill(255);  // Set fill to gray
rect(100, 100, 40, 50);  // Draw gray rect using CENTER mode

//Draw the ears
ellipseMode(CENTER);  // Set rectMode to CENTER
fill(200);  // Set fill to gray
ellipse(85, 50, 20, 50);  // Draw gray ellipse using CENTER mode

ellipseMode(CENTER);  // Set rectMode to CENTER
fill(200);  // Set fill to gray
ellipse(115, 50, 20, 50);  // Draw gray ellipse using CENTER mode

//Draw the eyes
ellipseMode(CENTER);  // Set rectMode to CENTER
fill(0);  // Set fill to gray
ellipse(92, 95, 10, 10);  // Draw gray ellipse using CENTER mode

ellipseMode(CENTER);  // Set rectMode to CENTER
fill(0);  // Set fill to gray
ellipse(108, 95, 10, 10);  // Draw gray ellipse using CENTER mode

//Draw the body
rectMode(CENTER);  // Set rectMode to CENTER
fill(255);  // Set fill to gray
rect(100, 150, 20, 50);  // Draw gray rect using CENTER mode

//Draw the legs
line(90,175,75,185);
line(110,175,125,185);

//Draw the arms
line(90,150,75,145);
line(110,150,125,145);
