package sk.thenet.geom;

/**
##2D Float point##

This class represents a point in 2D space as x and y coordinates.

Points are also immutable by design (the x and y properties are read-only).
Use one of the functions provided to get a different point or use the
constructor to replace points if needed.

@see `sk.thenet.geom.Point2DI` - a 2D point with integer coordinates.
 */
class Point2DF {
  /**
The x coordinate.
   */
  public var x(default, null):Float;

  /**
The y coordinate.
   */
  public var y(default, null):Float;
  
  public inline function new(x:Float, y:Float){
    this.x = x;
    this.y = y;
  }
  
  /**
Adds another point to this one, then returns the result.

@return `(this.x + other.x, this.y + other.y)`
   */
  public inline function add(other:Point2DF):Point2DF {
    return new Point2DF(x + other.x, y + other.y);
  }
  
  /**
Subtracts another point from this one, then returns the result.

@return `(this.x - other.x, this.y - other.y)`
   */
  public inline function subtract(other:Point2DF):Point2DF {
    return new Point2DF(x - other.x, y - other.y);
  }
  
  /**
Negates the components of this point, then returns the result.

@return `(-this.x, -this.y)`
   */
  public inline function negate():Point2DF {
    return new Point2DF(-x, -y);
  }
  
  /**
Scales the components of this point by a scalar, then returns the result.

@return `(this.x * factor, this.y * factor)`
   */
  public inline function scale(factor:Float):Point2DF {
    return new Point2DF(x * factor, y * factor);
  }
  
  /**
Multiplies the components of this point by the components of another point,
then returns the result.

@return `(this.x * other.x, this.y * other.y)`
   */
  public inline function multiply(other:Point2DF):Point2DF {
    return new Point2DF(x * other.x, y * other.y);
  }
  
  /**
Returns a normal vector to this point (a vector which is orthogonal to this
point).

@return `(this.y, -this.x)`
   */
  public inline function normal():Point2DF {
    return new Point2DF(y, -x);
  }
  
  /**
Calculates the magnitude of this point.
   */
  public inline function magnitude():Float {
    return Math.sqrt(x * x + y * y);
  }
  
  /**
Calculates the unit vector / normalised vector.
   */
  public inline function unit():Point2DF {
    return scale(1 / magnitude());
  }
  
  /**
Calculates the sum of the components of this point.
   */
  public inline function componentSum():Float {
    return x + y;
  }
  
  /**
Calculates the dot product of this point with another point.
   */
  public inline function dot(other:Point2DF):Float {
    return x * other.x + y * other.y;
  }
  
  public inline function toString():String {
    return '($x, $y)';
  }
}
