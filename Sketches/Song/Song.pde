import processing.serial.*;
import ddf.minim.*;
 
Serial myPort; 
Minim minim;
AudioPlayer player;
AudioPlayer player2;
String val;     // data received from the serial port
 
 
void setup(){
  size(500,500);
  //myPort = new Serial(this, "/dev/cu.usbmodem1411", 9600);
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 115200);
  myPort.buffer(1);
  minim = new Minim(this);
  player = minim.loadFile("Know.mp3");
  player2 = minim.loadFile("Sugar.mp3");
 
}
 
void draw(){
  
  cancion();
    
}

void cancion(){

  println(val);
  if ( myPort.available() > 0){  // If data is available,
  val = myPort.readString();         // read it and store it in val
  } 
  
  if(val == "1"){
    player.play();
    println("song1"); 
  }
 
  if(val == "2"){
    player2.play();
    println("song2");
  }
  else{    
        println("null");
  }

}
 