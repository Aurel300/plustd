package sk.thenet.bmp;

import haxe.ds.Vector;
import sk.thenet.geom.Point2DF;
import sk.thenet.geom.Point2DI;
import sk.thenet.stream.prng.Generator;

class PerlinNoise {
  public var generator:Generator;
  private var cachePoints:Array<Point2DI> = [];
  private var cacheValues:Array<Point2DF> = [];
  
  public function new(generator:Generator){
    this.generator = generator;
  }
  
  private function getPoint(x:Int, y:Int):Point2DF {
    for (ci in 0...cachePoints.length){
      if (cachePoints[ci].x != x || cachePoints[ci].y != y){
        continue;
      }
      return cacheValues[ci];
    }
    cachePoints.push(new Point2DI(x, y));
    var p = new Point2DF(generator.nextFloat() - .5, generator.nextFloat() - .5);
    if (p.x == 0 && p.y == 0){
      p = new Point2DF(1, 1);
    }
    p = p.unit();
    cacheValues.push(p);
    return p;
  }
  
  public function generateBlock(
    x:Int, y:Int, width:Int, height:Int
  ):Vector<Float> {
    inline function lerp(a:Float, b:Float, w:Float):Float {
      return (1.0 - w) * a + w * b;
    }
    
    inline function dotGridGradient(
      ix:Int, iy:Int, g:Point2DF, x:Float, y:Float
    ):Float {
      return ((x - ix) * g.x + (y - iy) * g.y);
    }
    
    var x0:Int = x;
    var x1:Int = x + 1;
    var y0:Int = y;
    var y1:Int = y + 1;
    
    var pt00:Point2DF = getPoint(x0, y0);
    var pt10:Point2DF = getPoint(x1, y0);
    var pt01:Point2DF = getPoint(x0, y1);
    var pt11:Point2DF = getPoint(x1, y1);
    
    var xf:Float;
    var yf:Float;
    
    var ret = new Vector<Float>(width * height);
    var i:Int = 0;
    for (py in 0...height){
      yf = py / height + y0;
      var sy:Float = yf - y0;
      
      for (px in 0...width){
        xf = px / width + x0;
        var sx:Float = xf - x0;
        
        var n0 = dotGridGradient(x0, y0, pt00, xf, yf);
        var n1 = dotGridGradient(x1, y0, pt10, xf, yf);
        var ix0 = lerp(n0, n1, sx);
        n0 = dotGridGradient(x0, y1, pt01, xf, yf);
        n1 = dotGridGradient(x1, y1, pt11, xf, yf);
        var ix1 = lerp(n0, n1, sx);
        
        ret[i] = lerp(ix0, ix1, sy);
        i++;
      }
    }
    return ret;
  }
}
