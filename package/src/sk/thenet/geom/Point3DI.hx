package sk.thenet.geom;

/**
##3D Integer point##

This class represents a point in 3D space as x, y, and z coordinates.

`Point3DI` is mostly identical to `Point3DF`, but it uses `Int` as the data type
for coordinates instead of `Float`. In some cases this might be faster, or more
desirable (for representing pixel-perfect 2D graphics).

There are two types of operations on points:

 - Cloning - These create a new instance of `Point3DI` that is the result of
applying the given operation. Suffixed with `C`.
 - Modifying - These modify the instance of `Point3DI`. Suffixed with `M`.

@see `Point3DF` for a 3D Float point.
 */
class Point3DI {
  /**
The x coordinate.
   */
  public var x:Int;
  
  /**
The y coordinate.
   */
  public var y:Int;
  
  /**
The z coordinate.
   */
  public var z:Int;
  
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
  public var componentSum(get, never):Int;
  
  private inline function get_componentSum():Int {
    return x + y + z;
  }
  
  public inline function new(x:Int, y:Int, z:Int){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  /**
@return Distance from `other`.
   */
  public inline function distance(other:Point3DI):Float {
    var dx:Float = x - other.x;
    var dy:Float = y - other.y;
    var dz:Float = z - other.z;
    return Math.sqrt(dx * dx + dy * dy + dz * dz);
  }
  
  /**
@return Manhattan (component-wise) distance from `other`.
   */
  public inline function distanceManhattan(other:Point3DI):Int {
    return FM.absI(other.x - x) + FM.absI(other.y - y) + FM.absI(other.z - z);
  }
  
  /**
@return Result of the dot product of this point with `other`.
   */
  public inline function dot(other:Point3DI):Int {
    return x * other.x + y * other.y + z * other.z;
  }
  
  /**
@return A copy of this point.
   */
  public inline function clone():Point3DI {
    return new Point3DI(x, y, z);
  }
  
  /**
@return A copy of this point, as a 3D Float point.
   */
  public inline function clone3DF():Point3DF {
    return new Point3DF(x, y, z);
  }
  
  /**
@return A copy of this point, with the signs of its coordinates flipped.
   */
  public inline function negateC():Point3DI {
    return new Point3DI(-x, -y, -z);
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
@return Result of adding `other` point to this one.
   */
  public inline function addC(other:Point3DI):Point3DI {
    return new Point3DI(x + other.x, y + other.y, z + other.z);
  }
  
  /**
Adds `other` to this point.
   */
  public inline function addM(other:Point3DI):Void {
    x += other.x;
    y += other.y;
    z += other.z;
  }
  
  /**
@return Result of subtracting `other` point from this one.
   */
  public inline function subtractC(other:Point3DI):Point3DI {
    return new Point3DI(x - other.x, y - other.y, z - other.z);
  }
  
  /**
Subtracts `other` point from this one.
   */
  public inline function subtractM(other:Point3DI):Void {
    x -= other.x;
    y -= other.y;
    z -= other.z;
  }
  
  /**
@return Result of scaling this point by a scalar `factor`.
   */
  public inline function scaleC(factor:Int):Point3DI {
    return new Point3DI(x * factor, y * factor, z * factor);
  }
  
  /**
Scales this point by a scalar `factor`.
   */
  public inline function scaleM(factor:Int):Void {
    x *= factor;
    y *= factor;
    z *= factor;
  }
  
  /**
@return Result of a component-wise multiplication of this point and `other`.
   */
  public inline function multiplyC(other:Point3DI):Point3DI {
    return new Point3DI(x * other.x, y * other.y, z * other.z);
  }
  
  /**
Component-wise multiplies this point and `other`.
   */
  public inline function multiplyM(other:Point3DI):Void {
    x *= other.x;
    y *= other.y;
    z *= other.z;
  }
  
  /**
@return A point whose coordinates are the absolute values of the coordinates of
this point.
   */
  public inline function absoluteC():Point3DI {
    return new Point3DI(FM.absI(x), FM.absI(y), FM.absI(z));
  }
  
  /**
Make the coordinates of this point positive.
   */
  public inline function absoluteM():Void {
    x = FM.absI(x);
    y = FM.absI(y);
    z = FM.absI(z);
  }
  
  public inline function toString():String {
    return '($x, $y, $z)';
  }
}
