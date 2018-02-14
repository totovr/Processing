// =================================================================
//global variables / objects
StopWatchTimer sw;
// =================================================================
// Main functions
void setup() {
  size(400, 400);
  println (millis());
  sw = new StopWatchTimer();
  sw.start();
}
void draw () {
  time();
}
// =================================================================
// Other functions
void time() {
  background(#FFFFFF);
  fill(#000000);
  textAlign(CENTER);
  text(nf(sw.hour(), 2)+":"+nf(sw.minute(), 2)+":"+nf(sw.second(), 2), 150, 175);
}