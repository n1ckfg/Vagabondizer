import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
import processing.opengl.PGraphics2D;
import processing.opengl.PGraphics3D;

DwPixelFlow context;
DwFilter filter;
float bloomMult = 0.3; //3.5; // 0.0-10.0
float bloomRadius = 0.5; //0.5; // 0.0-1.0

void bloomSetup() { 
  context = new DwPixelFlow(this);
  filter = new DwFilter(context);
  filter.bloom.param.mult = bloomMult;
  filter.bloom.param.radius =  bloomRadius;
}
