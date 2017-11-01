import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
kinect = new SimpleOpenNI(this);
// enable depthMap and RGB image
kinect.enableDepth();
kinect.enableIR();
// enable mirror
kinect.setMirror(true);
size(kinect.depthWidth()+kinect.irWidth(), kinect.depthHeight());
}

void draw() {
kinect.update();
// draw depthImageMap and RGB images
image(kinect.depthImage(), 0, 0);
image(kinect.irImage(),kinect.depthWidth(),0);
}
