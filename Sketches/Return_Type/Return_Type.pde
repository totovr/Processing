int x = sum(5,6,8);
int y = sum(8,9,10) * 2;
int z = sum(x,y,40);
line(100,100,110,sum(x,y,z));

int sum(int a, int b, int c) {
  int total = a + b + c;
  return total;
}
