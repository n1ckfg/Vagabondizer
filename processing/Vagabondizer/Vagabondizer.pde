SvgObj obj;

void setup() {
  size(1920, 1080, FX2D);
  frameRate(30);
  obj = new SvgObj(loadShape("test2.svg"));
}

int y = 200;

void draw() {
  obj.draw(0, y);
  y--;
}
