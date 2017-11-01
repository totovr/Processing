int val, xVal, yVal;

void setup() {
  Serial.begin(9600);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
}

void loop(){
  
    // check if enough data has been sent from the computer:
    if (Serial.available()>2) {
    // Read the first value. This indicates the beginning of the communication.
    val = Serial.read();
    // If the value is the event trigger character 'S'
    if(val == 'S'){
    // read the most recent byte, which is the x-value
    xVal = Serial.read();
    // Then read the y-value
    yVal = Serial.read();
    }
   }
 // And send those to the LEDS!
  analogWrite(10, xVal);
  analogWrite(11, yVal);
}
