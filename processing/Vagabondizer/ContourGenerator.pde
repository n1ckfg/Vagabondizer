import gab.opencv.*;

class ContourGenerator {
  
  OpenCV opencv;
  int strokeLength, curStrokeLength, numSlices;
  float approx, minArea;
  ArrayList<Contour> contours;
  PShape result;
  
  ContourGenerator(PApplet sketch, PImage _img) {
    strokeLength = 40;
    curStrokeLength = strokeLength;
    approx = 0.05;
    minArea = 20.0;
    numSlices = 20;
    
    result = createShape(GROUP);
    opencv = new OpenCV(sketch, _img);
    doContours();
    processContours(_img);
  }
  
  void processContours(PImage _img) {
    for (int i=0; i<contours.size(); i++) {         
      Contour contour = contours.get(i);
      
      if (contour.area() >= minArea) { 
        ArrayList<PVector> pOrig = contour.getPolygonApproximation().getPoints();
        ArrayList<PVector> p = new ArrayList<PVector>();
        ArrayList<Integer> cols = new ArrayList<Integer>();
        PVector firstPoint = pOrig.get(0);
        
        color col = getColor(_img.pixels, firstPoint.x, firstPoint.y, _img.width); 
        
        for (int j=0; j<pOrig.size(); j++) {
          PVector pt = pOrig.get(j);
          col = getColor(_img.pixels, pt.x, pt.y, _img.width);    
          cols.add(col);
          p.add(new PVector(pt.x / float(_img.width), 1.0 - (pt.y / float(_img.width))));
        
          if (p.size() > curStrokeLength || (j > pOrig.size()-1 && p.size() > 0)) {
            PShape child = createShape();
            child.beginShape();
            for (int k=0; k<p.size(); k++) {
              color c1 = cols.get(k);
              child.stroke(red(c1), green(c1), blue(c1), 255);
              PVector p1 = p.get(k);
              child.vertex(p1.x, p1.y);
            }
            p = new ArrayList<PVector>();
            curStrokeLength = int(random(strokeLength/2, strokeLength*2));
            child.endShape();
            result.addChild(child);
          }
        }
      }            
    }
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

}
