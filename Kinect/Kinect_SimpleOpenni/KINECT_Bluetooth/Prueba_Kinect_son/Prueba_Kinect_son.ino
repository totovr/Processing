int button = 10;
int buttonState = 0;
int led = 12;

void setup() {
  pinMode(button, INPUT);
  pinMode(led, OUTPUT);
  Serial.begin(38400); // Default communication rate of the Bluetooth module
}

void loop() {
 buttonState = digitalRead(button);
 PullUp();
}

void PullUp() {
    if (buttonState == HIGH) {
      digitalWrite(led, HIGH);
      Serial.write('1'); // Sends '1' to the master to turn on LED
      delay(10);
    }
    else {
      digitalWrite(led, LOW);
      Serial.write('0');
      delay(10);
    }  
    delay(10); // Wait 10 milliseconds for next reading
}
