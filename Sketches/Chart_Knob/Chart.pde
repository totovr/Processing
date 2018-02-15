//Libraries
import processing.serial.*;
import controlP5.*;

//Objects
ControlP5 cp5;
Serial myPort;  // Create object from Serial class
Knob myKnobA;

//Variables
int myColorBackground = color(0,0,0);

void setup() {
  size(700,400);
  smooth();
  noStroke();

  cp5 = new ControlP5(this);

  myKnobA = cp5.addKnob("Life")
               .setRange(0,100)
               .setValue(100)
               .setPosition(100,70)
               .setRadius(120)
               .setNumberOfTickMarks(20)
               .setTickMarkLength(8)
               .snapToTickMarks(true)
               .setColorForeground(color(255))
               .setColorBackground(color(0, 160, 100))
               .setColorActive(color(255,255,0))
               .setDragDirection(Knob.VERTICAL)
               ;
}

void draw() {
  background(myColorBackground);
  fill(250);
}

void keyPressed() {
  switch(key) {
    case('1'):myKnobA.setValue(50);break;
    case('2'):myKnobA.setValue(90);break;
  }
}