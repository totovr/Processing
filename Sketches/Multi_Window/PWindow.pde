

class PWindow extends PApplet {
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(800, 450);
  }

  void setup() {
    background(250);
  }

  void draw() {
  
    ellipse(random(width), random(height), random(50), random(50));
  }

  void mousePressed() {
    println("mousePressed in secondary window");
  }
}