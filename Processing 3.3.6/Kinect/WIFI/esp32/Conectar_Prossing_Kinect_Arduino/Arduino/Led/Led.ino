char val; // Data received from the serial port
int ledPin = 14; // Set the pin to digital I/O 14
int ledPIN = 33; // Set the pin to digital I/O 7

void setup() {
   pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
   pinMode(ledPIN, OUTPUT); // Set pin as OUTPUT
   Serial.begin(115200); // Start serial communication at 9600 bps
 }

void loop() {
   
  if (Serial.available()) 
     { // If data is available to read,
     val = Serial.read(); // read it and store it in val
     }
     
  if (val == '1') 
    { // If 1 was received
     digitalWrite(ledPin, HIGH); // turn the LED ON
     digitalWrite(ledPIN, LOW); // turn the LED OFF
    } 
   
   else {
     digitalWrite(ledPin, LOW); // otherwise turn it OFF
     digitalWrite(ledPIN, HIGH); // otherwise turn it ON
   }
   delay(10); // Wait 10 milliseconds for next reading
}
