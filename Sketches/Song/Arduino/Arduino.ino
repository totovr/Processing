  
  const int inputPin_1 = 2;  //pin for pullup resistor
  const int inputPin_2 = 4;  //pin for pullup resistor
  
  int value_1 = 0;
  int value_2 = 0;
  
  int lastvalue_1;
  int lastvalue_2;
  
  int lastvalue = 0;     // previous state of the button

  void setup() {
  
    Serial.begin(9600);      //Start serial communication
  
    }
  
  void loop(){
      
      value_1 = digitalRead(inputPin_1);  //read the digital input
      Song_1();
      Song_2();
  
    }
  
  void Song_1(){  
      
      if (value_1 != lastvalue_1) {
        if (value_1 == LOW) {
            Serial.println("1");
            Serial.println("Sent!");
            delay(2000);
        }
      }  
  
      lastvalue_1 = value_1;
  
    }

    void Song_2(){  
      
      if (value_2 != lastvalue_2) {
        if (value_1 == LOW) {
            Serial.println("2");
            Serial.println("Sent!");
            delay(2000);
        }
      }  
  
      lastvalue_2 = value_2;
  
    }
