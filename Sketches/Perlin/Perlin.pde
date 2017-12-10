int cols, rows;
int scl = 20;
int w = 600;
int h = 600;

void setup(){
  
  size(600, 600, P3D);
  //Columns and rows size
  cols = w/scl;
  rows = h/scl;
  
}

void draw(){
  background(0);
  stroke(255);
  noFill();
  
  translate(width/2, height/2);
  rotateX(PI/3);
  
  translate(-w/2, -h/2);
  for (int y = 0; y < cols; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {     
      vertex(x*scl,y*scl, random(-10,10));
      vertex(x*scl,(y+1)*scl, random(-10,10));
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
  //Activate to save video
  //saveFrame("output/line-######.png");  
}