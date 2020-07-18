SvgObj obj;

int scaler = 2;
int w = 2160;
int h = 2160;
int vertStep = -5;

boolean firstRun = true;
int yPos = 0;

int childStep = 500;
int pointStep = 25;
int alpha = 35;
float strokeWeightVal = 0.75;
float shake = 2;

boolean record = true;

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
    
    if (record) {
        String savePath = sketchPath("") + "/render/" + fileName + "_" + zeroPadding(counter++,10000) + ".png";
        obj.gfx.save(savePath);
    }
  }
}
