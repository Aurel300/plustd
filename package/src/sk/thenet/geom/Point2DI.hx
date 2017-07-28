package sk.thenet.geom;

/**
##2D Integer point##

This class represents a point in 2D space as x and y coordinates.

`Point2DI` is mostly identical to `Point2DF`, but it uses `Int` as the data type
for coordinates instead of `Float`. In some cases this might be faster, or more
desirable (for representing pixel-perfect 2D graphics).

There are two types of operations on points:

 - Cloning - These create a new instance of `Point2DI` that is the result of
applying the given operation. Suffixed with `C`.
 - Modifying - These modify the instance of `Point2DI`. Suffixed with `M`.

@see `Point2DF` for a 2D Float point.
 */
class Point2DI {
  /**
The x coordinate.
   */
  public var x:Int;
  
  /**
The y coordinate.
   */
  public var y:Int;
  
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
  public var componentSum(get, never):Int;
  
  private inline function get_componentSum():Int {
    return x + y;
  }
  
  public inline function new(x:Int, y:Int) {
    this.x = x;
    this.y = y;
  }
  
  /**
@return Distance from `other`.
   */
  public inline function distance(other:Point2DI):Float {
    var dx:Int = x - other.x;
    var dy:Int = y - other.y;
    return Math.sqrt(dx * dx + dy * dy);
  }
  
  /**
@return Manhattan (component-wise) distance from `other`.
   */
  public inline function distanceManhattan(other:Point2DI):Int {
    return FM.absI(other.x - x) + FM.absI(other.y - y);
  }
  
  /**
@return Result of the dot product of this point with `other`.
   */
  public inline function dot(other:Point2DI):Int {
    return x * other.x + y * other.y;
  }
  
  /**
@return A copy of this point.
   */
  public inline function clone():Point2DI {
    return new Point2DI(x, y);
  }
  
  /**
@return A copy of this point, as a 2D Float point.
   */
  public inline function clone2DF():Point2DF {
    return new Point2DF(x, y);
  }
  
  /**
@return A copy of this point, as a 3D Integer point. The z coordinate is set to
0.
   */
  public inline function clone3DI():Point3DI {
    return new Point3DI(x, y, 0);
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
  public inline function negateC():Point2DI {
    return new Point2DI(-x, -y);
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
  public inline function normalC():Point2DI {
    return new Point2DI(y, -x);
  }
  
  /**
Turns this point 90 degrees.
   */
  public inline function normalM():Void {
    var t:Int = x;
    x = y;
    y = -x;
  }
  
  /**
@return Result of adding `other` point to this one.
   */
  public inline function addC(other:Point2DI):Point2DI {
    return new Point2DI(x + other.x, y + other.y);
  }
  
  /**
Adds `other` to this point.
   */
  public inline function addM(other:Point2DI):Void {
    x += other.x;
    y += other.y;
  }
  
  /**
@return Result of subtracting `other` point from this one.
   */
  public inline function subtractC(other:Point2DI):Point2DI {
    return new Point2DI(x - other.x, y - other.y);
  }
  
  /**
Subtracts `other` point from this one.
   */
  public inline function subtractM(other:Point2DI):Void {
    x -= other.x;
    y -= other.y;
  }
  
  /**
@return Result of scaling this point by a scalar `factor`.
   */
  public inline function scaleC(factor:Int):Point2DI {
    return new Point2DI(x * factor, y * factor);
  }
  
  /**
Scales this point by a scalar `factor`.
   */
  public inline function scaleM(factor:Int):Void {
    x *= factor;
    y *= factor;
  }
  
  /**
@return Result of a component-wise multiplication of this point and `other`.
   */
  public inline function multiplyC(other:Point2DI):Point2DI {
    return new Point2DI(x * other.x, y * other.y);
  }
  
  /**
Component-wise multiplies this point and `other`.
   */
  public inline function multiplyM(other:Point2DI):Void {
    x *= other.x;
    y *= other.y;
  }
  
  /**
@return A point whose coordinates are the absolute values of the coordinates of
this point.
   */
  public inline function absoluteC():Point2DI {
    return new Point2DI(FM.absI(x), FM.absI(y));
  }
  
  /**
Make the coordinates of this point positive.
   */
  public inline function absoluteM():Void {
    x = FM.absI(x);
    y = FM.absI(y);
  }
  
  public inline function toString():String {
    return '($x, $y)';
  }
}
