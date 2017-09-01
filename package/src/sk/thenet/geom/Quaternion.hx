package sk.thenet.geom;

import haxe.ds.Vector;

/**
##Quaternion##

This class represents quaternions, or 4-dimensional numbers. They are a useful
tool when dealing with 3D transformations and rotations. For simplicity, this
class is an extension of `Point4DF`. Its coordinates represent:

 - `x` - The real part of a quaternion.
 - `y` - The imaginary `i` coefficient.
 - `z` - The imaginary `j` coefficient.
 - `w` - The imaginary `k` coefficient.
 */
class Quaternion extends Point4DF {
  /**
@return A quaternion representing no transformation.
   */
  public static inline function identity():Quaternion {
    return new Quaternion(1, 0, 0, 0);
  }
  
  /**
@return A quaternion representing the rotation of `angle` radians around `axis`.
   */
  public static inline function ofAxis(axis:Point3DF, angle:Float):Quaternion {
    var s = Math.sin(angle / 2);
    return new Quaternion(
         Math.cos(angle / 2)
        ,s * axis.x
        ,s * axis.y
        ,s * axis.z
      );
  }
  
  /**
@return A quaternion whose vector part is `p`.
   */
  public static inline function ofPoint(p:Point3DF):Quaternion {
    return new Quaternion(0, p.x, p.y, p.z);
  }
  
  /**
@return A quaternion whose real part is `a`.
   */
  public static inline function ofReal(a:Float):Quaternion {
    return new Quaternion(a, 0, 0, 0);
  }
  
  /**
The point consisting of the coefficients of the imaginary unit vectors.
   */
  public var point(get, never):Point3DF;
  
  private inline function get_point():Point3DF {
    return new Point3DF(y, z, w);
  }
  
  /**
Creates a new quaternion - mathematically, it will be
`a + b * i + c * j + d * k`, where `i`, `j`, and `k` are the mutually orthogonal
imaginary unit vectors.
   */
  public inline function new(a:Float, b:Float, c:Float, d:Float) {
    super(a, b, c, d);
  }
  
  /**
@return Result of rotating `p` using this quaternion as a versor.
   */
  public inline function rotate(p:Point3DF):Point3DF {
    var q = multiplyQuatC(Quaternion.ofPoint(p));
    return q.multiplyQuatM(inverseC()).point;
  }
  
  /**
@return A conjugate of this quaternion.
   */
  public inline function conjugateC():Quaternion {
    return new Quaternion(x, -y, -z, -w);
  }
  
  /**
Changes this quaternion into its conjugate.
   */
  public inline function conjugateM():Void {
    y = -y;
    z = -z;
    w = -w;
  }
  
  /**
@return An inverse of this quaternion.
   */
  public inline function inverseC():Quaternion {
    var len = magnitude;
    var conj = conjugateC();
    conj.scaleM(1 / (len * len));
    return conj;
  }
  
  /**
Changes this quaternion into its inverse.
   */
  public inline function inverseM():Void {
    var len = magnitude;
    conjugateM();
    scaleM(1 / (len * len));
  }
  
  /**
@return Result of mulitplying this quaternion with `other`.
   */
  public inline function multiplyQuatC(other:Quaternion):Quaternion {
    return new Quaternion(
         x * other.x - y * other.y - z * other.z - w * other.w
        ,x * other.y + y * other.x + z * other.w - w * other.z
        ,x * other.z - y * other.w + z * other.x + w * other.y
        ,x * other.w + y * other.z - z * other.y + w * other.x
      );
  }
  
  /**
Multiplies this quaternion by `other`.

@return This quaternion after modification.
   */
  public inline function multiplyQuatM(other:Quaternion):Quaternion {
    var nx = x * other.x - y * other.y - z * other.z - w * other.w;
    var ny = x * other.y + y * other.x + z * other.w - w * other.z;
    var nz = x * other.z - y * other.w + z * other.x + w * other.y;
    w = x * other.w + y * other.z - z * other.y + w * other.x;
    x = nx;
    y = ny;
    z = nz;
    return this;
  }
}
