class Spot{
  float x, y;
  float x0, y0, c0;
  float amplitudeX, amplitudeY;
  
  Spot(float _x, float _y) {
    x = _x;
    y = _y;
  }
  
  void init() {
    x0 = x;
    y0 = y;
    c0 = random(255);
  }
    
  void move() {
    x = x0 + amplitudeX*sin(frameCount*PI/60);
    y = y0 + amplitudeY*sin(frameCount*PI/60);
    if (frameCount%60 == 0) {
      amplitudeX = random(-100, 100);
      amplitudeY = random(-100, 100);
      }
  }
  
  void display() {
    fill(c0, 204, 204);
    ellipse(x, y, 6, 6);
  }
  
}