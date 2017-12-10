import processing.video.*;

Circles[] circles;


void setup(){
  size(1000,1000);
  smooth();
  frameRate(24);
  circles = new Circles[700];
  
  for(int i = 0; i < circles.length; i++){
    circles[i] = new Circles(random(width),random(height),random(5,15),random(10,70),random(-4,5),random(-4,5),i);
  }
}

void draw(){
  background(0);
  
  for(int i = 0; i < circles.length; i++){
    //circles[i].ellColor();
    //circles[i].collisions();
    circles[i].cLines();
    circles[i].update();
    circles[i].display();
  }
  
  //Activate to save video
  //saveFrame("output/line-######.png");
}