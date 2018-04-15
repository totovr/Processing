class Walker {
  int x;
  int y;

  Walker() {
    x = width/2;
    y = height/2;
  }

  void display() {
    stroke(0);
    point(x,y);
  }

  void step() {
    float stepx = random(-1, 1);
    float stepy = random(-1, 1);
    x += stepx;
    y += stepy;
  }
}
