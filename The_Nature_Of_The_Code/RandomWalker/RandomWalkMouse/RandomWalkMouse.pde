Walker w;

void setup() {
  size(640, 360);
  w = new Walker();
  background(255);

}

void draw() {
  w.display();
  w.step(mouseX, mouseY);
}
