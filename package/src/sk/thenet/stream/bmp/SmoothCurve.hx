package sk.thenet.stream.bmp;

import haxe.ds.Vector;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.geom.Point2DI1DF;
import sk.thenet.stream.Stream;

abstract SmoothCurve(Iterator<Point2DI1DF>)
  from Iterator<Point2DI1DF>
  to Iterator<Point2DI1DF>
{
  public inline function new(stream:Iterator<Point2DI1DF>) {
    this = stream;
  }
  
  public inline function apply(
    target:Bitmap, colour:Colour, ?bounded:Bool = true
  ):Int {
    var points = 0;
    for (p in this) {
      if (p.x < 0 || p.x >= target.width || p.y < 0 || p.y >= target.height) {
        if (bounded) {
          break;
        }
        continue;
      }
      target.set(p.x, p.y, colour.mulAf(p.v).blendWith(target.get(p.x, p.y)));
      points++;
    }
    return points;
  }
  
  public inline function applyVector(
     target:Vector<Colour>, width:Int, height:Int
    ,colour:Colour, ?bounded:Bool = true
  ):Int {
    var points = 0;
    for (p in this) {
      if (p.x < 0 || p.x >= width || p.y < 0 || p.y >= height) {
        if (bounded) {
          break;
        }
        continue;
      }
      target[p.x + p.y * width] = colour.mulAf(p.v).blendWith(
          target[p.x + p.y * width]
        );
      points++;
    }
    return points;
  }
}
