class Ball {

  // x location
  float x;
  // y location
  float y;
  // speed
  float speed;
  // gravity
  float w;

  Ball(float Tempx, float Tempy, float Tempspeed, float Tempw) {
    x = Tempx;
    y = Tempy;
    speed = Tempspeed;
    w = Tempw;
  }

  void display () {
    // display the square
    fill(255);
    noStroke();
    ellipseMode(CENTER);
    ellipse(x,y,10,10);
  }

  void move() {
    // Add speed to y location
    y = y + speed;
    // Add gravity to speed
    speed = speed + w;
    // If square reaches the bottom
    // Reverse speed
    if (y > height) {
    speed = speed * -0.95;
    }
  }
}
