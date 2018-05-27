long startTime = System.currentTimeMillis();
long stopTime;
long result;
String user_detected = "Yes";
String skeleton = "Yes";

void setup(){
}

void draw(){
  //user_detected = "yes";
  if(user_detected == "Yes") {
    result = System.currentTimeMillis() - startTime;
    println("The deph image takes " + result);
    user_detected = "No";
    result = 0;
    startTime = millis();
    delay(50);
    //exit();
  }
  if(skeleton == "Yes") {
    stopTime = millis();
    result = stopTime - startTime;
    println("Skeleton takes " + result);
    skeleton = "No";
    //exit();
  }
}
