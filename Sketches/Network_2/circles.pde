class Circles{
  float x,y;
  float ellSize;
  float alph;
  
  float vx;
  float vy;
  float id;
  float ellColor;
  float gradient;
  //Circles[] others;


    //constructor
Circles(float _x, float _y, float _ellSize, float _alph, float _vx, float _vy, int _id /*Circles[] oin*/){
      x = _x;
      y = _y;
      ellSize = _ellSize;
      alph = _alph;
      vx = _vx;
      vy = _vy;
      id = _id;
      //others = oin;
    }

    //methods
void update(/*float vx, float xy*/){
  int n = (width+50);
    x+=vx;
    y+=vy;
    
    if(x>n){
      vx--;
      //x = width;
    }
    if(x<-50){
      vx++;
    }
    if(y>n){
      vy--;
    }
    if(y<-50){
      vy++;
    }
    
    }
/*    
void collisions(){
        noStroke();
        fill(255,alph);
        for(int i = 0; i < circles.length; i++){
            if(id != i){
                if(dist(x,y,circles[i].x, circles[i].y) < ellSize/2 + circles[i].ellSize/2){
                  noStroke();
                  fill(255,0,0,alph);
                }
            }
        }
    }*/
    
    
  void ellColor(){
    fill(255,0,0);      
    for(int i = 0; i < circles.length; i++){
       if(dist(x,y,circles[i].x, circles[i].y) < ellSize*1.5 + circles[i].ellSize*1.5){
         gradient = map(dist(x,y,circles[i].x, circles[i].y),ellSize,ellSize*2,250,150);
         fill(255,gradient);
       }
    }
  }

  void display(){
    fill(255,alph);
    noStroke();
    ellipse(x,y,ellSize,ellSize);
  }
    
  void cLines(){
    stroke(255,50);
    strokeWeight(.9);
    for(int i = 0; i < circles.length; i++) {
        if(dist(x,y,circles[i].x, circles[i].y) < ellSize*4 + circles[i].ellSize*4){
           line(x,y,circles[i].x, circles[i].y);
         }
    }
  }    
}