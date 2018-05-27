long t = System.currentTimeMillis();
// do slow stuff

void setup() {
}

void draw() {
  println(System.currentTimeMillis() - t);
}

void keyPressed() {
  if(key == ESC) {
    println(millis());
  }
}
