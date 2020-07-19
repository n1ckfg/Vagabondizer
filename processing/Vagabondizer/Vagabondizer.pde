SvgObj obj;
boolean firstRun = true;
float yPos = 0;

String url = "test2.svg";
int w = 3840;
int h = 2160;
boolean record = true;
int scaler = 3;
float vertStep = -1;
int childStep = 100;
int pointStep = 15;
int alpha = 35;
float strokeWeightVal = 0.2;
float shake = 2;

Settings settings;

void setup() {
  size(50, 50, P2D);
  settings = new Settings("settings.txt");
  frameRate(60);
}


void draw() { 
  if (firstRun) {
    obj = new SvgObj(loadShape(url), w, h, childStep, pointStep, alpha, strokeWeightVal, shake);
    obj.refineObj();
    obj.cleanObj();
    
    surface.setSize(obj.w / scaler, obj.h / scaler);
    firstRun = false;
  } else {
    background(0);
    
    obj.draw(0, yPos);
    yPos += vertStep;
    
    image(obj.gfx, 0, 0, width, height);
    
    //filter(INVERT);
    
    if (record) {
        String savePath = sketchPath("") + "/render/" + fileName + "_" + zeroPadding(counter++,10000) + ".png";
        obj.gfx.save(savePath);
    }
  }
}
