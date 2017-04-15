package sk.thenet.geom;

/**
##2D Integer point##

This class is mostly identical to `sk.thenet.geom.Point2DF`, but it uses `Int`
as the data type for coordinates instead of `Float`. In some cases this might
be faster, or more desirable (for representing pixel-perfect 2D graphics).

@see `sk.thenet.geom.Point2DF`
 */
class Point2DI {
  public var x(default, null):Int;
  public var y(default, null):Int;
  
  public inline function new(x:Int, y:Int){
    this.x = x;
    this.y = y;
  }
  
  public inline function add(other:Point2DI):Point2DI {
    return new Point2DI(x + other.x, y + other.y);
  }
  
  public inline function subtract(other:Point2DI):Point2DI {
    return new Point2DI(x - other.x, y - other.y);
  }
  
  public inline function negate():Point2DI {
    return new Point2DI(-x, -y);
  }
  
  public inline function scale(factor:Int):Point2DI {
    return new Point2DI(x * factor, y * factor);
  }
  
  public inline function multiply(other:Point2DI):Point2DI {
    return new Point2DI(x * other.x, y * other.y);
  }
  
  public inline function normal():Point2DI {
    return new Point2DI(y, -x);
  }
  
  public inline function magnitude():Float {
    return Math.sqrt(x * x + y * y);
  }
  
  public inline function componentSum():Int {
    return x + y;
  }
  
  public inline function dot(other:Point2DI):Int {
    return x * other.x + y * other.y;
  }
  
  public inline function toString():String {
    return '($x, $y)';
  }
}
