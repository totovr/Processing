import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Chart_Knob extends PApplet {

//Libraries



//Objects
ControlP5 cp5;
Serial myPort;  // Create object from Serial class
Knob myKnobA;

//Variables
int val;
int valor = 0;
//Timer variables
float a = 0;
//knob Variables
int life = 100;


public void setup() {
        
        
        noStroke();
        //New cp5 constructor
        cp5 = new ControlP5(this);
        myKnobA = cp5.addKnob("Life")
                  .setViewStyle(2)
                  .setRange(0,100)
                  .setValue(life)
                  .setPosition(100,70)
                  .setRadius(120)
                  .hideTickMarks()
                  .setNumberOfTickMarks(20)
                  .setTickMarkLength(8)
                  .snapToTickMarks(true)
                  .setColorForeground(color(255,255,0,191))
                  .setColorBackground(color(0, 160, 100))
                  //.setColorActive(color(255,255,0))
                  .setDragDirection(Knob.VERTICAL)
        ;

        background(valor, 0, 0);

        String portName = Serial.list()[5]; //change the 0 to a 1 or 2 etc. to match your port
        myPort = new Serial(this, portName, 115200);
        while (a < 3000) {         // cycle of 3 seconds duration, during this time
                a = millis ();
        }                          // you need to press the RESET buttom.
}

public void draw() {
        Serial_read();
}

public void Serial_read(){
        if(myPort.available() > 0)
        { // If data is available,
                valor = myPort.read(); // read it and store it in val
                println(valor);
                if (valor == 100) {
                        life = life - 20;
                        myKnobA.setValue(life);

                }
        }
}
  public void settings() {  size(700,400);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Chart_Knob" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
