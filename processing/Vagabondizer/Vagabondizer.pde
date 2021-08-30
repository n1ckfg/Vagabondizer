boolean record = true;
boolean refine = true;
int scaler = 1;
int childStep = 100;
int pointStep = 15;
int alpha = 35;
float strokeWeightVal = 0.2;
float shake = 2;
int newW, newH;
ContourGenerator cg;
int renderLimit = 100;
boolean doClear = false;
boolean useFills = true;

Settings settings;

void setup() {
  size(50, 50, P2D);
  settings = new Settings("data/settings.txt"); 
  frameRate(60); 

  chooseFolderDialog();
}
 
void draw() {
  if (filesLoaded) {
    if (firstRun) {
      filesSetup();
      bloomSetup();
      opticalFlowSetup();  
    } else {
      try {
        background(0);
        cg.run();
      } catch (Exception e) { }
    }
  }
}
