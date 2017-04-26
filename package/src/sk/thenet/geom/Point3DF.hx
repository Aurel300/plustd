package sk.thenet.geom;

/**
##3D Float point##

This class represents a point in 3D space as x, y, and z coordinates.

There are two types of operations on points:

 - Cloning - These create a new instance of `Point3DF` that is the result of
applying the given operation. Suffixed with `C`.
 - Modifying - These modify the instance of `Point3DF`. Suffixed with `M`.

@see `Point3DI` - a 3D point with integer coordinates.
 */
class Point3DF {
  /**
The x coordinate.
   */
  public var x:Float;
  
  /**
The y coordinate.
   */
  public var y:Float;
  
  /**
The z coordinate.
   */
  public var z:Float;
  
  /**
Magnitude of this point.
   */
  public var magnitude(get, never):Float;
  
  private inline function get_magnitude():Float {
    return Math.sqrt(x * x + y * y + z * z);
  }
  
  /**
The sum of the components of this point.
   */
  public var componentSum(get, never):Float;
  
  private inline function get_componentSum():Float {
    return x + y + z;
  }
  
  public inline function new(x:Float, y:Float, z:Float){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  /**
@return Distance from `other`.
   */
  public inline function distance(other:Point3DF):Float {
    var dx:Float = x - other.x;
    var dy:Float = y - other.y;
    var dz:Float = z - other.z;
    return Math.sqrt(dx * dx + dy * dy + dz * dz);
  }
  
  /**
@return Manhattan (component-wise) distance from `other`.
   */
  public inline function distanceManhattan(other:Point3DF):Float {
    return FM.absF(other.x - x) + FM.absF(other.y - y) + FM.absF(other.z - z);
  }
  
  /**
@return Result of the dot product of this point with `other`.
   */
  public inline function dot(other:Point3DF):Float {
    return x * other.x + y * other.y + z * other.z;
  }
  
  /**
@return A copy of this point.
   */
  public inline function clone():Point3DF {
    return new Point3DF(x, y, z);
  }
  
  /**
@return A copy of this point, with the signs of its coordinates flipped.
   */
  public inline function negateC():Point3DF {
    return new Point3DF(-x, -y, -z);
  }
  
  /**
Changes the signs of the coordinates of this point.
   */
  public inline function negateM():Void {
    x = -x;
    y = -y;
    z = -z;
  }
  
  /**
@return A point with the same direction as this one, but its magnitude equal to
1.
   */
  public inline function unitC():Point3DF {
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
  public inline function addC(other:Point3DF):Point3DF {
    return new Point3DF(x + other.x, y + other.y, z + other.z);
  }
  
  /**
Adds `other` to this point.
   */
  public inline function addM(other:Point3DF):Void {
    x += other.x;
    y += other.y;
    z += other.z;
  }
  
  /**
@return Result of subtracting `other` point from this one.
   */
  public inline function subtractC(other:Point3DF):Point3DF {
    return new Point3DF(x - other.x, y - other.y, z - other.z);
  }
  
  /**
Subtracts `other` point from this one.
   */
  public inline function subtractM(other:Point3DF):Void {
    x -= other.x;
    y -= other.y;
    z -= other.z;
  }
  
  /**
@return Result of scaling this point by a scalar `factor`.
   */
  public inline function scaleC(factor:Float):Point3DF {
    return new Point3DF(x * factor, y * factor, z * factor);
  }
  
  /**
Scales this point by a scalar `factor`.
   */
  public inline function scaleM(factor:Float):Void {
    x *= factor;
    y *= factor;
    z *= factor;
  }
  
  /**
@return Result of a component-wise multiplication of this point and `other`.
   */
  public inline function multiplyC(other:Point3DF):Point3DF {
    return new Point3DF(x * other.x, y * other.y, z * other.z);
  }
  
  /**
Component-wise multiplies this point and `other`.
   */
  public inline function multiplyM(other:Point3DF):Void {
    x *= other.x;
    y *= other.y;
    z *= other.z;
  }
  
  /**
@return A point whose coordinates are the absolute values of the coordinates of
this point.
   */
  public inline function absoluteC():Point3DF {
    return new Point3DF(FM.absF(x), FM.absF(y), FM.absF(z));
  }
  
  /**
Make the coordinates of this point positive.
   */
  public inline function absoluteM():Void {
    x = FM.absF(x);
    y = FM.absF(y);
    z = FM.absF(z);
  }
  
  public inline function toString():String {
    return '($x, $y, $z)';
  }
}
