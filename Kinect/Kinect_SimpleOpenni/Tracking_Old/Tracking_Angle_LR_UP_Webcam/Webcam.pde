  class Webcam extends PApplet {
    Webcam() {
      super();
      PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
    }

  Capture cam;
  
  void settings() {
    size(1280,960);
  }

  void setup() {String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {

      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
      }
    // The camera can be initialized directly using an
    // element from the array returned by list():
    cam = new Capture(this, cameras[1]);
    cam.start();

    }
  }

  void draw() {

    if (cam.available() == true) {
    cam.read();
    }
    image(cam, 0, 0);
  }


}
