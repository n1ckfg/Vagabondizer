class SvgObj {
  
  PShape shp;
  ArrayList<SvgObjChild> obj;
  String url;
  int w;
  int h;
  int childCounter = 0;
  int childStep = 100;
  float scaler = 1.0;
  
  SvgObj(PShape _shape) {
    shp = _shape;
    
    init();
  }
  
  SvgObj(String _url) {
    url = _url;
    shp = loadShape(url);
    
    init();
  }
  
  void init() {
    w = (int) shp.width;
    h = (int) shp.height;
    scaler = (float) width / (float) w;
    
    obj = new ArrayList<SvgObjChild>();
    
    for (int i=0; i<shp.getChildCount(); i++) {
      obj.add(new SvgObjChild(shp.getChild(i)));
    }
  }
  
  void draw(float x, float y) {
    pushMatrix();
    translate(x, y);
    scale(scaler);
    
    for (int i=0; i<childCounter; i++) {
      obj.get(i).draw();
    }
    
    popMatrix();
    
    if (childCounter < obj.size() - childStep) {
      childCounter += childStep;
    } else {
      childCounter = obj.size() - 1;
    }
  }
  
}

class SvgObjChild {

  ArrayList<PVector> points;
  color strokeColor;
  color fillColor;
  float strokeWeightVal = 1;
  int pointsCounter = 0;
  int pointStep = 100;

  SvgObjChild(PShape _shape) {
    points = new ArrayList<PVector>();
    
    try {
      strokeColor = _shape.getStroke(0);
    } catch (Exception e) {
      strokeColor = color(0);
    }
    
    try {
      fillColor = _shape.getFill(0);
    } catch (Exception e) {
      fillColor = color(127);
    }
    
    for (int i=0; i<_shape.getVertexCount(); i++) {
      points.add(_shape.getVertex(i));
    }
  }
  
  void setMaterial(boolean doStroke, boolean doFill) {
    if (doStroke && strokeWeightVal > 0.00001) {
      strokeWeight(strokeWeightVal);
      stroke(strokeColor);
    } else {
      noStroke();
    }
    
    if (doFill) {
      fill(fillColor);
    } else {
      noFill();
    }
  }
  
  void draw() {
    setMaterial(true, true);
  
    beginShape();
    for (int i=0; i<pointsCounter; i++) {
      PVector p = points.get(i);
      vertex(p.x, p.y);
    }
    endShape();

    if (pointsCounter < points.size()-pointStep) {
      pointsCounter += pointStep;
    } else {
      pointsCounter = points.size() - 1;
    }
  }
   
}
