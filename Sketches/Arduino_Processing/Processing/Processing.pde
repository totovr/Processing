import processing.serial.*;

Serial myPort;  // Create object from Serial class
int valor = 255;


void setup() 
{
  size(200, 200);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 115200);
  background(valor, 0, 0);
}

void draw()
{  
  if (myPort.available() > 0) { 
         valor = myPort.read();  
         println(valor);
         if (valor == 100) {
         int xcolor = 100;
         background(xcolor, xcolor, 0); 
         } else {
           background(valor, 0, 0);
         }
      }
}