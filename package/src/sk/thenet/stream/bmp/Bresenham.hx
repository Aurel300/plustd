package sk.thenet.stream.bmp;

import sk.thenet.FM;
import sk.thenet.geom.Point2DI;
import sk.thenet.stream.Stream;

class Bresenham extends Stream<Point2DI> {
  public static inline function getCurve(
    from:Point2DI, to:Point2DI, ?ray:Bool = false
  ):Curve {
    return new Curve(new Bresenham(from, to, ray));
  }
  
  public static function getTopDown(from:Point2DI, to:Point2DI):Bresenham {
    if (from.y > to.y){
      return new Bresenham(to, from);
    } else if (from.y == to.y && from.x > to.x){
      return new Bresenham(to, from);
    }
    return new Bresenham(from, to);
  }
  
  public var yLong(default, null):Bool;
  
  public function new(from:Point2DI, to:Point2DI, ?ray:Bool = false){
    var x = from.x;
    var y = from.y;
    
    var dx = FM.absI(to.x - x);
    var sx = x < to.x ? 1 : -1;
    
    var dy = FM.absI(to.y - y);
    var sy = y < to.y ? 1 : -1; 
    
    yLong = dy > dx;
    
    var err:Float = (dx > dy ? dx : -dy) / 2;
    
    var finished = false;
    
    super(ray ? Stream.always : function():Bool {
        return !finished;
      }, function():Point2DI {
        var ret = new Point2DI(x, y);
        if (x == to.x && y == to.y){
          finished = true;
        } else {
          var e2 = err;
          if (e2 > -dx){
            err -= dy;
            x += sx;
          }
          if (e2 < dy){
            err += dx;
            y += sy;
          }
        }
        return ret;
      });
  }
}
