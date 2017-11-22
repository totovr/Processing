import processing.serial.*;
import processing.net.*;
 
 
 
String myString ;
String host = " " ;
int lf = 10;    // Linefeed in ASCII
Serial myPort;  // The serial port
Client c;
PFont myFont;
 
void setup() {
 
  size(200,200); //make our canvas 200 x 200 pixels big 
  
  // Open the port you are using at the rate you want:
  //String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
 
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  myString = null;
 
 
}
 
void draw() {
       
 
      while (myPort.available() > 0) {
       myString = myPort.readStringUntil(lf);
          if (myString != null) {
 
             host = myString.substring(0 , 11) ;
            println(host);
 
          }
 
      }
      c = new Client(this, host , 80); // Connect to server on port 80
 
//      if((mouseX>=25&&mouseX<=75)&&(mouseY>=25&&mouseY<=75))
//        {
//              if(mousePressed==true)
//                {
//                  c.write('n');
//                }
//         }
// 
//       if((mouseX>=80&&mouseX<=130)&&(mouseY>=80&&mouseY<=130))
//        {
//             if(mousePressed==true)
//               {
//                c.write('f');
//               }
//         }

      if (mousePressed == true) 
  {                           //if we clicked in the window
   myPort.write('1');         //send a 1
   println("1");   
  } else 
  {                           //otherwise
  myPort.write('0');
  println("0");  //send a 0
  } 
  
}
