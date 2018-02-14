Spot spot;
ArrayList spots;

float a = 0;

void setup() {
  size(1240,720);
  smooth();
  noStroke();
  colorMode(HSB);
  frameRate(60);
  //spot = new Spot(width/2, height/2);
  //spot.init();
  spots = new ArrayList();
  for (int i = 0; i < 300; i++) {
    spots.add(new Spot(random(width), random(height)));
    Spot spot = (Spot) spots.get(spots.size()-1);
    spot.init();
  }
  
}

void draw() {
  background(0);
  //spot.move();
  //spot.display();
  spot();
}

void spot() {
    for (int i = 0; i < 300; i++) {
    Spot spot = (Spot) spots.get(i);
    spot.move();
    spot.display();
  } 
}