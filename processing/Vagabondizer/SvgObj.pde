class SvgObj {
  
  PGraphics gfx;
  PShape shp;
  ArrayList<SvgObjChild> obj;
  int w;
  int h;
  int childCounter;
  int childStep;
  int pointStep;
  int alpha;
  float strokeWeightVal;
  float shake;
  float scaler;
  color bgColor;
  boolean finished = false;
  
  SvgObj(PShape _shape, int _w, int _childStep, int _pointStep, int _alpha, float _strokeWeightVal, float _shake) {
    shp = _shape;   
    pointStep = _pointStep;
    childStep = _childStep;
    alpha = _alpha;
    shake = _shake;   
    strokeWeightVal = _strokeWeightVal;
    
    childCounter = 0;
    scaler = 1.0;
    bgColor = color(255);
    
    init(_w);
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
  
  void init(int _w) {
    w = _w;  
    scaler = (float) w / (float) shp.width;
    h = int(scaler * shp.height);
    gfx = createGraphics(w, h, P2D);
    
    obj = new ArrayList<SvgObjChild>();
    
    for (int i=0; i<shp.getChildCount(); i++) {
      obj.add(new SvgObjChild(shp.getChild(i), gfx, pointStep, alpha, strokeWeightVal, shake));
    }
  }
  
  void draw(float x, float y) {   
    gfx.beginDraw();
    //gfx.background(bgColor);
    gfx.pushMatrix();
    gfx.translate(x, y);
    gfx.scale(scaler);
    
    for (int i=0; i<childCounter; i++) {
      obj.get(i).draw();
    }
    
    gfx.popMatrix();
    
    if (childCounter < obj.size() - childStep) {
      childCounter += childStep;
      finished = false;
    } else {
      childCounter = obj.size() - 1;
    }
    
    gfx.endDraw();

    for (int i=0; i<obj.size(); i++) {
      if (!obj.get(i).finished) return;
    }
    
    finished = true;
  }
  
}

// ~ ~ ~ ~ ~ ~

class SvgObjChild {

  ArrayList<PVector> points;
  color strokeColor;
  color fillColor;
  float strokeWeightVal;
  int pointsCounter;
  int pointStep;
  PGraphics gfx;
  int alpha;
  float shake;
  boolean finished = false;
  
  SvgObjChild(PShape _shape, PGraphics _gfx, int _pointStep, int _alpha, float _strokeWeightVal, float _shake) {
    gfx = _gfx;
    pointStep = _pointStep;
    alpha = _alpha;
    strokeWeightVal = _strokeWeightVal;
    shake = _shake;
    
    points = new ArrayList<PVector>();
    pointsCounter = 0;
    
    try {
      strokeColor = color(_shape.getStroke(0), alpha);
    } catch (Exception e) {
      strokeColor = color(0, alpha);
    }
    
    try {
      fillColor = color(_shape.getFill(0), alpha);
    } catch (Exception e) {
      fillColor = color(127, alpha);
    }
    
    for (int i=0; i<_shape.getVertexCount(); i++) {
      points.add(_shape.getVertex(i));
    }
  }
  
  void setMaterial(boolean doStroke, boolean doFill) {
    if (doStroke && strokeWeightVal > 0.00001) {
      gfx.strokeWeight(strokeWeightVal);
      gfx.stroke(strokeColor);
    } else {
      gfx.noStroke();
    }
    
    if (doFill) {
      gfx.fill(fillColor);
    } else {
      gfx.noFill();
    }
  }
    
  void smoothPoints() {
    float weight = 18;
    float scale = 1.0 / (weight + 2);
    int nPointsMinusTwo = points.size() - 2;
    PVector lower, upper, center;

    for (int i = 1; i < nPointsMinusTwo; i++) {
      lower = points.get(i-1);
      center = points.get(i);
      upper = points.get(i+1);

      center.x = (lower.x + weight * center.x + upper.x) * scale;
      center.y = (lower.y + weight * center.y + upper.y) * scale;
    }
  }

  void splitPoints() {
    for (int i = 1; i < points.size(); i+=2) {
      PVector center = points.get(i);
      PVector lower = points.get(i-1);
      float x = (center.x + lower.x) / 2;
      float y = (center.y + lower.y) / 2;
      float z = (center.z + lower.z) / 2;
      PVector p = new PVector(x, y, z);
      points.add(i, p);
    }
  }

  void refinePoints() {
    int smoothReps = 10;
    int splitReps = 2;
    
    for (int i=0; i<splitReps; i++) {
      splitPoints();  
      smoothPoints();  
    }
    for (int i=0; i<smoothReps - splitReps; i++) {
      smoothPoints();    
     }
  }
  
  void draw() {
    setMaterial(true, true);
  
    gfx.beginShape();
    for (int i=0; i<pointsCounter; i++) {
      PVector p = points.get(i);
      if (shake > 0.001) {
        gfx.vertex(p.x + shake * (random(1) - 0.5), p.y + shake * (random(1) - 0.5));
      } else {
        gfx.vertex(p.x, p.y);
      }
    }
    gfx.endShape();

    if (pointsCounter < points.size()-pointStep) {
      pointsCounter += pointStep;
      finished = false;
    } else {
      pointsCounter = points.size() - 1;
      finished = true;
    }
  }
   
}
