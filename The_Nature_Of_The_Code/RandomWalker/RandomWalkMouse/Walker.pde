class Walker {

float x;
float y;

float xPos;
float yPos;

Walker() {
  x = width/2;
  y = height/2;
}

void display() {
        stroke(0);
        point(xPos,yPos);
}

void step(float xTemp, float yTemp) {
  xPos = xTemp;
  yPos = yTemp;
        //generate a value between 0 and 1
        float r = random(1);
        if(r < 0.5) {
                xPos++;
                yPos++;
        } else {
                xPos--;
                yPos--;
        }
}
}
