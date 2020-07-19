SvgObj obj;
boolean firstRun = true;

String url = "test2.svg";
int w = 1920;
boolean record = true;
int scaler = 3;
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
    obj = new SvgObj(loadShape(url), w, childStep, pointStep, alpha, strokeWeightVal, shake);
    obj.smoothObj();
    
    surface.setSize(obj.w / scaler, obj.h / scaler);
    firstRun = false;
  } else {
    background(0);
    
    obj.draw(0, 0);
    
    image(obj.gfx, 0, 0, width, height);
       
    if (record) {
        String savePath = sketchPath("") + "/render/" + fileName + "_" + zeroPadding(counter++,10000) + ".png";
        obj.gfx.save(savePath);
    }
    
    if (obj.finished) exit();
  }
}
