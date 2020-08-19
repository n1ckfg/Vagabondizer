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
  PShape shp;
  
  SvgObjChild(PShape _shape, PGraphics _gfx, int _pointStep, int _alpha, float _strokeWeightVal, float _shake) {
    shp = _shape;
    gfx = _gfx;
    pointStep = _pointStep;
    alpha = _alpha;
    strokeWeightVal = _strokeWeightVal;
    shake = _shake;
    
    points = new ArrayList<PVector>();
    pointsCounter = 0;
    
    for (int i=0; i<_shape.getVertexCount(); i++) {
      points.add(_shape.getVertex(i));
    }
  }
  
  void setMaterial(int index, boolean _doFill) {   
    gfx.strokeWeight(strokeWeightVal);

    try {
      strokeColor = color(shp.getStroke(index), alpha);
    } catch (Exception e) {
      strokeColor = color(127, alpha);
    }
    
    try {
      fillColor = color(shp.getStroke(index), alpha);
    } catch (Exception e) {
      fillColor = color(127, alpha);
    }
    
    if (_doFill) {
        gfx.stroke(strokeColor);   
        gfx.fill(fillColor);
    } else {
        gfx.stroke(fillColor);   
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
    int smoothReps = 2; //10;
    int splitReps = 1; //2;
    
    for (int i=0; i<splitReps; i++) {
      splitPoints();  
      smoothPoints();  
    }
    for (int i=0; i<smoothReps - splitReps; i++) {
      smoothPoints();    
     }
  }
  
  void draw() {  
    gfx.beginShape();
    for (int i=0; i<pointsCounter; i++) {
      PVector p = points.get(i);
      setMaterial(i, useFills); //true);
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
