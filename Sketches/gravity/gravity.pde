// Simple gravity

Ball ball1;
Ball ball2;

void setup() {
    size(400,400);
    ball1 = new Ball(100, 0, 0, 0.3);
    ball2 = new Ball(300, 0, 0, 0.1);
}
void draw() {
    background(100);
    ball1.display();
    ball1.move();
    ball2.display();
    ball2.move();
}
