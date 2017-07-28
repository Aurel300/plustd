package sk.thenet.geom;

import sk.thenet.FM;

/**
##2D Float point##

This class represents a point in 2D space as x and y coordinates.

There are two types of operations on points:

 - Cloning - These create a new instance of `Point2DF` that is the result of
applying the given operation. Suffixed with `C`.
 - Modifying - These modify the instance of `Point2DF`. Suffixed with `M`.

@see `Point2DI` - a 2D point with integer coordinates.
 */
class Point2DF {
  /**
The x coordinate.
   */
  public var x:Float;
  
  /**
The y coordinate.
   */
  public var y:Float;
  
  /**
Magnitude of this point.
   */
  public var magnitude(get, never):Float;
  
  private inline function get_magnitude():Float {
    return Math.sqrt(x * x + y * y);
  }
  
  /**
The sum of the components of this point.
   */
  public var componentSum(get, never):Float;
  
  private inline function get_componentSum():Float {
    return x + y;
  }
  
  public inline function new(x:Float, y:Float) {
    this.x = x;
    this.y = y;
  }
  
  /**
@return Distance from `other`.
   */
  public inline function distance(other:Point2DF):Float {
    var dx:Float = x - other.x;
    var dy:Float = y - other.y;
    return Math.sqrt(dx * dx + dy * dy);
  }
  
  /**
@return Manhattan (component-wise) distance from `other`.
   */
  public inline function distanceManhattan(other:Point2DF):Float {
    return FM.absF(other.x - x) + FM.absF(other.y - y);
  }
  
  /**
@return Result of the dot product of this point with `other`.
   */
  public inline function dot(other:Point2DF):Float {
    return x * other.x + y * other.y;
  }
  
  /**
@return A copy of this point.
   */
  public inline function clone():Point2DF {
    return new Point2DF(x, y);
  }
  
  /**
@return A copy of this point, as a 3D Float point. The z coordinate is set to 0.
   */
  public inline function clone3DF():Point3DF {
    return new Point3DF(x, y, 0);
  }
  
  /**
@return A copy of this point, with the signs of its coordinates flipped.
   */
  public inline function negateC():Point2DF {
    return new Point2DF(-x, -y);
  }
  
  /**
Changes the signs of the coordinates of this point.
   */
  public inline function negateM():Void {
    x = -x;
    y = -y;
  }
  
  /**
@return A point that is perpendicular to this one.
   */
  public inline function normalC():Point2DF {
    return new Point2DF(y, -x);
  }
  
  /**
Turns this point 90 degrees.
   */
  public inline function normalM():Void {
    var t:Float = x;
    x = y;
    y = -x;
  }
  
  /**
@return A point with the same direction as this one, but its magnitude equal to
1.
   */
  public inline function unitC():Point2DF {
    return scaleC(1 / magnitude);
  }
  
  /**
Scales this point so that its magnitude is 1.
   */
  public inline function unitM():Void {
    scaleM(1 / magnitude);
  }
  
  /**
@return Result of adding `other` point to this one.
   */
  public inline function addC(other:Point2DF):Point2DF {
    return new Point2DF(x + other.x, y + other.y);
  }
  
  /**
Adds `other` to this point.
   */
  public inline function addM(other:Point2DF):Void {
    x += other.x;
    y += other.y;
  }
  
  /**
@return Result of subtracting `other` point from this one.
   */
  public inline function subtractC(other:Point2DF):Point2DF {
    return new Point2DF(x - other.x, y - other.y);
  }
  
  /**
Subtracts `other` point from this one.
   */
  public inline function subtractM(other:Point2DF):Void {
    x -= other.x;
    y -= other.y;
  }
  
  /**
@return Result of scaling this point by a scalar `factor`.
   */
  public inline function scaleC(factor:Float):Point2DF {
    return new Point2DF(x * factor, y * factor);
  }
  
  /**
Scales this point by a scalar `factor`.
   */
  public inline function scaleM(factor:Float):Void {
    x *= factor;
    y *= factor;
  }
  
  /**
@return Result of a component-wise multiplication of this point and `other`.
   */
  public inline function multiplyC(other:Point2DF):Point2DF {
    return new Point2DF(x * other.x, y * other.y);
  }
  
  /**
Component-wise multiplies this point and `other`.
   */
  public inline function multiplyM(other:Point2DF):Void {
    x *= other.x;
    y *= other.y;
  }
  
  /**
@return A point whose coordinates are the absolute values of the coordinates of
this point.
   */
  public inline function absoluteC():Point2DF {
    return new Point2DF(FM.absF(x), FM.absF(y));
  }
  
  /**
Make the coordinates of this point positive.
   */
  public inline function absoluteM():Void {
    x = FM.absF(x);
    y = FM.absF(y);
  }
  
  public inline function toString():String {
    return '($x, $y)';
  }
}
