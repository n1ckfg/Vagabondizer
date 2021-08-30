OpenCV opencv2;
int levelOfDetail = 2;
int videoScale = 8;
int videoWidth, videoHeight;
PImage motionTexture;
PShader shaderBuffer;
PGraphics[] renderArray;
int currentRender;
float lerpSpeed = 0.05;
int sW, sH;
PGraphics texScale;

void opticalFlowSetup() {
  sW = cg.obj.gfx.width;
  sH = cg.obj.gfx.height;
  videoWidth = cg.obj.gfx.width / videoScale;
  videoHeight = cg.obj.gfx.height / videoScale;
  texScale = createGraphics(videoWidth, videoHeight, P2D);

  opencv2 = new OpenCV(this, videoWidth, videoHeight);
  motionTexture = createImage(videoWidth / levelOfDetail, videoHeight / levelOfDetail, RGB);
  shaderBuffer = loadShader("shaders/Buffer.frag", "shaders/Simple.vert");
  renderArray = new PGraphics[2];
  currentRender = 0;
  
  for (int i = 0; i < renderArray.length; i++) {
    renderArray[i] = createGraphics(sW, sH, P2D);

    renderArray[i].beginDraw();
    renderArray[i].background(0);
    renderArray[i].endDraw();

    // nearest filter mode
    ((PGraphicsOpenGL)renderArray[i]).textureSampling(2);
  }
}

void opticalFlowDraw() {
  opencv2.useGray();
  texScale.beginDraw();
  texScale.image(cg.obj.gfx, 0, 0, texScale.width, texScale.height);
  texScale.endDraw();
  opencv2.loadImage(texScale);
  opencv2.calculateOpticalFlow();
  opencv2.useColor(PApplet.RGB);

  motionTexture.loadPixels();
  for (int x = 0; x < motionTexture.width; x++) {
    for (int y = 0; y < motionTexture.height; y++) {
      // get the vector motion from openCV
      PVector motion = opencv2.getFlowAt(x * levelOfDetail, y * levelOfDetail);

      PVector direction = getNormal(motion.x, motion.y);

      // get index array from 2d position
      int index = x + y * motionTexture.width;
  
      // encode vector into a color
      colorMode(RGB, 1, 1, 1);
      motionTexture.pixels[index] = color(direction.x * 0.5 + 0.5, direction.y * 0.5 + 0.5, min(1, motion.mag()));
      colorMode(RGB, 255, 255, 255);
    }
  }

  motionTexture.updatePixels();

  PGraphics bufferWrite = getCurrentRender();
  nextRender();
  PGraphics bufferRead = getCurrentRender();

  // start recording render texture
  bufferWrite.beginDraw();

  shaderBuffer.set("frame", bufferRead);
  shaderBuffer.set("motion", motionTexture);
  shaderBuffer.set("frameOrig", opencv2.getOutput());
  shaderBuffer.set("lerpSpeed", lerpSpeed);

  // apply pixel displacement with shader
  bufferWrite.shader(shaderBuffer);
  bufferWrite.rect(0, 0, sW, sH);

  bufferWrite.endDraw();

  // draw final render
  cg.obj.gfx.beginDraw();
  cg.obj.gfx.blendMode(LIGHTEST);
  cg.obj.gfx.image(bufferWrite, 0, 0, cg.obj.gfx.width, cg.obj.gfx.height);
  cg.obj.gfx.blendMode(BLEND);
  cg.obj.gfx.endDraw();  
}

// the current frame buffer
PGraphics getCurrentRender() {
  return renderArray[currentRender];
}

// swap between writing frame and reading frame
void nextRender() {
  currentRender = (currentRender + 1) % renderArray.length;
}

// return normalized vector
PVector getNormal(float x, float y) {
  float dist = sqrt(x*x+y*y);
  return new PVector(x / dist, y / dist);
}
