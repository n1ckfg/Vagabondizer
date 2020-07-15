MeshObj obj;

void setup() {
  size(50, 50, P2D);
  obj = new MeshObj(loadShape("test1.svg"));
  //surface.setSize(sw.width, sw.height); 
}

void draw() {
  obj.draw();
}
