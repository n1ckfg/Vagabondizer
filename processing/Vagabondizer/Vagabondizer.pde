SvgObj obj;

int scaler = 1;
int w = 1080;
int h = 1080;
int vertStep = -5;

boolean firstRun = true;
int yPos = 0;

int childStep = 500;
int pointStep = 25;
int alpha = 35;
float strokeWeightVal = 0.75;
float shake = 1;

void setup() {
  size(50, 50, P2D);
  frameRate(60);
}


void draw() { 
  if (firstRun) {
    obj = new SvgObj(loadShape("test2.svg"), w, h, childStep, pointStep, alpha, strokeWeightVal, shake);
    obj.smoothObj();
    
    surface.setSize(obj.w / scaler, obj.h / scaler);
    firstRun = false;
  } else {
    background(0);
    
    obj.draw(0, yPos);
    yPos += vertStep;
    
    image(obj.gfx, 0, 0, width, height);
    
    filter(INVERT);
  }
}
