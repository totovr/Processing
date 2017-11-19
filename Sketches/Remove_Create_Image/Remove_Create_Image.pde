PImage pic;
int value = 0;
float x, y = 0;

void setup(){ 
  
  size(500,500); 
  //loading the picture 
  pic = loadImage("pet.jpeg"); 
  background(0,100,0);
  
}

void draw(){
  
  background(0,100,0);
  image(pic, x,y, 100,100); 

}

void mouseClicked(){
  
  x = random(500);
  y = random(500);
  redraw();  
}