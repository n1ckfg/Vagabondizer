class SvgObj {
  
  PGraphics2D gfx;
  PShape shp;
  ArrayList<SvgObjChild> obj;
  int childCounter;
  int childStep;
  int pointStep;
  int alpha;
  float strokeWeightVal;
  float shake;
  color bgColor;
  boolean finished = false;
  boolean doClear = false;
  
  SvgObj(PShape _shape, PImage _img, int _childStep, int _pointStep, int _alpha, float _strokeWeightVal, float _shake) {
    shp = _shape;   
    pointStep = _pointStep;
    childStep = _childStep;
    alpha = _alpha;
    shake = _shake;   
    strokeWeightVal = _strokeWeightVal;
    
    childCounter = 0;
    bgColor = color(255);
    
    gfx = (PGraphics2D) createGraphics(_img.width, _img.height, P2D);
    
    obj = new ArrayList<SvgObjChild>();
    
    for (int i=0; i<shp.getChildCount(); i++) {
      obj.add(new SvgObjChild(shp.getChild(i), gfx, pointStep, alpha, strokeWeightVal, shake));
    }
  }
  
  void smoothObj() {
    for (int i=0; i<obj.size(); i++) {
      SvgObjChild objChild = obj.get(i);
      objChild.smoothPoints();
    }
  }
  
    void splitObj() {
    for (int i=0; i<obj.size(); i++) {
      SvgObjChild objChild = obj.get(i);
      objChild.splitPoints();
    }
  }
  
  void refineObj() {
    for (int i=0; i<obj.size(); i++) {
      SvgObjChild objChild = obj.get(i);
      objChild.refinePoints();
    }
  }
  
  void cleanObj() {
    int cleanMinPoints = 1;
    float cleanMinLength = 0.1;
  
    for (int i=0; i<obj.size(); i++) {
      SvgObjChild objChild = obj.get(i);

          // 1. Remove the stroke if it has too few points.
          if (objChild.points.size() < cleanMinPoints) {
            obj.remove(i);
          } else {
            float totalLength = 0.0;
            for (int l=1; l<objChild.points.size(); l++) {
              PVector p1 = objChild.points.get(l);
              PVector p2 = objChild.points.get(l-1);
              // 2. Remove the point if it's a duplicate.
              if (hitDetect3D(p1, p2, 0.1)) {
                objChild.points.remove(l);
              } else {
                totalLength += PVector.dist(p1, p2);
              }
            }
            // 3. Remove the stroke if its length is too small.
            if (totalLength < cleanMinLength) {
              obj.remove(i);
            } else {
              // 4. Finally, check the number of points again.
              if (objChild.points.size() < cleanMinPoints) {
                obj.remove(i);
              }
            }
      }
    } 
  }
  
  boolean hitDetect3D(PVector p1, PVector p2, float s) { 
    if (PVector.dist(p1, p2) < s) {
      return true;
    } else {
      return false;
    }
  }

  void draw(float x, float y) {   
    gfx.beginDraw();
    if (doClear) gfx.clear();
    
    for (int i=0; i<childCounter; i++) {
      obj.get(i).draw();
    }
        
    if (childCounter < obj.size() - childStep) {
      childCounter += childStep;
      finished = false;
    } else {
      childCounter = obj.size() - 1;
    }
    
    // * * * * * * * * * * *
    opticalFlowDraw();
    filter.bloom.apply(gfx);
    // * * * * * * * * * * *
    gfx.endDraw();

    for (int i=0; i<obj.size(); i++) {
      if (!obj.get(i).finished) return;
    }
    
    finished = true;
  }
  
}
