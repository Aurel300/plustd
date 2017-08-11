package sk.thenet.stream.bmp;

import haxe.ds.Vector;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.geom.Point2DI;
import sk.thenet.stream.Stream;

abstract Curve(Iterator<Point2DI>) from Iterator<Point2DI> to Iterator<Point2DI> {
  public inline function new(stream:Iterator<Point2DI>) {
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
      target.set(p.x, p.y, colour);
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
      target[p.x + p.y * width] = colour;
      points++;
    }
    return points;
  }
}
