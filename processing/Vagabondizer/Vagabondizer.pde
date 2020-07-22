SvgObj obj;
boolean firstRun = true;

String url = "test2.svg";
int w = 1920;
boolean record = true;
boolean refine = true;
int scaler = 3;
int childStep = 100;
int pointStep = 15;
int alpha = 35;
float strokeWeightVal = 0.2;
float shake = 2;
int newW, newH;

Settings settings;

void setup() {
  size(50, 50, P2D);
  settings = new Settings("settings.txt");
  frameRate(60);
}


void draw() { 
  if (firstRun) {
    obj = new SvgObj(loadShape(url), w, childStep, pointStep, alpha, strokeWeightVal, shake);
    if (refine) {
      obj.refineObj();
      obj.cleanObj();
    }
    newW = obj.gfx.width / scaler;
    newH = obj.gfx.height / scaler;
    surface.setSize(newW, newH);
    
    println("Render: " + obj.w + " x " + obj.h + "   Display: " + newW + " x " + newH);
    firstRun = false;
  } else {
    background(0);
    
    obj.draw(0, 0);
    
    image(obj.gfx, 0, 0, newW, newH);
       
    if (record) {
        String savePath = sketchPath("") + "/render/" + fileName + "_" + zeroPadding(counter++,10000) + ".png";
        obj.gfx.save(savePath);
    }
    
    if (obj.finished) exit();
  }
}
