PImage img1, img2;

void setup() {
  img1 = loadImage("Yo.jpg");
  img2 = loadImage("Yo.jpg");
  img2.filter(GRAY);
}

void draw() {
  image(img1, 0, 0);
  image(img2, width/2, 0);
}