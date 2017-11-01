import processing.serial.*;
Serial myPort;

void setup()
{
  size(255, 255);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  noStroke();
  rect(0,0,width/2,height);

if (mouseX>width/2) {
  myPort.write('1');
  }
  else {
    myPort.write('0');
  }
}


//void draw(){
//  // Create a gradient for visualisation
//  for(int i = 0; i<width; i++){
//  stroke(i);
//  line(i,0,i,height);
//  }
//// Send the value of the mouse's x-position
//myPort.write(mouseX);
//}
