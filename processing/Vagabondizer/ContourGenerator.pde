import java.util.Collections;

class ContourGenerator {
  
  int numSlices;
  float approx, minArea;
  ArrayList<Contour> contours;
  PImage img;
  PShape result;
  SvgObj obj;
  int renderCounter;
  
  ContourGenerator(PImage _img) {
    img = _img;

    approx = 0.05;
    minArea = 20.0;
    numSlices = 20;   
      
    result = createShape(GROUP);
    setupOpenCv(img);
    doContours();
    processContours(img);  
    
    renderCounter = 0;
    firstRun = false;
  }
  
  void processContours(PImage _img) {
    Collections.reverse(contours); // draw from top down instead of bottom up
    
    for (int i=0; i<contours.size(); i++) {         
      Contour contour = contours.get(i);
      
      if (contour.area() >= minArea) {         
        ArrayList<PVector> p = contour.getPolygonApproximation().getPoints();
        //println("Found a contour with " + p.size() + " points.");
        
        PShape child = createShape();
        child.beginShape();        
        for (int j=0; j<p.size(); j++) {
          PVector pt = p.get(j);
          color col = getColor(_img.pixels, pt.x, pt.y, _img.width);    
          child.stroke(col);
          child.vertex(pt.x, pt.y);
        }

        child.endShape();
        result.addChild(child);
      }   
    }
    
    obj = new SvgObj(result, img, childStep, pointStep, alpha, strokeWeightVal, shake);
    obj.doClear = doClear;
    if (refine) {
      obj.refineObj();
      obj.cleanObj();
    }
    
    newW = (int) obj.gfx.width / scaler;
    newH = (int) obj.gfx.height / scaler;
    surface.setSize(newW, newH);
    
    println("Render: " + obj.gfx.width + " x " + obj.gfx.height + ", Display: " + newW + " x " + newH);
  }
  
  void doContours() {
    contours = new ArrayList<Contour>();
    for (int i=0; i<255; i += int(255/numSlices)) {
      doContour(i);
    }
  }
    
  void doContour(int thresh) {  
    opencv.gray();
    opencv.threshold(thresh);
    ArrayList<Contour> newContours = opencv.findContours();
    
    for (Contour contour : newContours) {
      contour.setPolygonApproximationFactor(contour.getPolygonApproximationFactor() * approx);
      contours.add(contour);
    }
  }
  
  int getLoc(float x, float y, int w) {
    return int(x) + int(y) * w;
  }
  
  color getColor(color[] px, float x, float y, int w) {
    return px[getLoc(x, y, w)];
  }
  
  float getZ(color[] px, float x, float y, int w) {
    return red(px[getLoc(x, y, w)]);
  }

  void run() {    
    obj.draw(0,0);
    image(obj.gfx, 0, 0, width, height);
    
    if (record) {
        String savePath = sketchPath("") + "/render/" + saveName + "/" + saveName + "_" + zeroPadding(renderCounter,10000) + ".png";
        obj.gfx.save(savePath);
    }
    
    renderCounter++;
    if (obj.finished || renderCounter > renderLimit) {
      renderCounter = 0;
      fileLoop();
    }
  }
}
