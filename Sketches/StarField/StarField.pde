//Create a new object
Star[] stars = new Star[800];
float speed;
void setup() {
  size(800, 800);
  //Draw the field
  for(int i = 0; i < stars.length; i++) {
    //index
    stars[i] = new Star();
  }
}

void draw() {
  speed = map(mouseX, 0, width, 0, 50);
  background(0);
  translate(width/2, height/2);
  for(int i = 0; i < stars.length; i++) {
    stars[i].update();
    stars[i].show();
  }
  //Activate to save video
  //saveFrame("output/line-######.png");
}