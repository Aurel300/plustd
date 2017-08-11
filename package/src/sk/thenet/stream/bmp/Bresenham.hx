package sk.thenet.stream.bmp;

import sk.thenet.FM;
import sk.thenet.geom.Point2DI;
import sk.thenet.stream.Stream;

class Bresenham {
  public static inline function getCurve(
    from:Point2DI, to:Point2DI, ?ray:Bool = false
  ):Curve {
    return new Curve(new Bresenham(from, to, ray));
  }
  
  public static function getTopDown(from:Point2DI, to:Point2DI):Bresenham {
    if (from.y > to.y) {
      return new Bresenham(to, from);
    } else if (from.y == to.y && from.x > to.x) {
      return new Bresenham(to, from);
    }
    return new Bresenham(from, to);
  }
  
  public var yLong(default, null):Bool;
  public var ray  (default, null):Bool;
  
  public var x(default, null):Int;
  public var y(default, null):Int;
  
  private var finished:Bool = false;
  private var to:Point2DI;
  private var sx:Int;
  private var sy:Int;
  private var dx:Int;
  private var dy:Int;
  private var err:Float;
  
  public function new(from:Point2DI, to:Point2DI, ?ray:Bool = false) {
    this.ray = ray;
    this.to  = to;
    
    x = from.x;
    y = from.y;
    
    dx = FM.absI(to.x - x);
    sx = x < to.x ? 1 : -1;
    dy = FM.absI(to.y - y);
    sy = y < to.y ? 1 : -1; 
    
    yLong = dy > dx;
    
    err = (dx > dy ? dx : -dy) / 2;
  }
  
  public function hasNext():Bool {
    return ray || !finished;
  }
  
  public function next():Point2DI {
    var ret = new Point2DI(x, y);
    if (x == to.x && y == to.y) {
      finished = !ray;
    } else {
      var e2 = err;
      if (e2 > -dx) {
        err -= dy;
        x += sx;
      }
      if (e2 < dy) {
        err += dx;
        y += sy;
      }
    }
    return ret;
  }
}
