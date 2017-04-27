package sk.thenet.geom;

import haxe.ds.Vector;

/**
##Quaternion##

This class represents quaternions, or 4-dimensional numbers. They are a useful
tool when dealing with 3D transformations and rotations.

There are two types of operations on quaternions:

 - Cloning - These create a new instance of `Quaternion` that is the result of
applying the given operation. Suffixed with `C`.
 - Modifying - These modify the instance of `Quaternion`. Suffixed with `M`.
 */
class Quaternion {
  /**
@return A quaternion representing the rotation of `angle` radians around `axis`.
   */
  public static function axisRotation(axis:Point3DF, angle:Float):Quaternion {
    var s = Math.sin(angle / 2);
    return new Quaternion(
         Math.cos(angle / 2)
        ,s * axis.x
        ,s * axis.y
        ,s * axis.z
      );
  }
  
  /**
@return A quaternion representing no transformation.
   */
  public static inline function identity():Quaternion {
    return new Quaternion(1, 0, 0, 0);
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
Note: this does not ensure unit length - if the result is to be used as a
versor, it has to be normalised using `unitM()`.

@return The linear interpolation of this quaternion and `other`.
   */
  public static inline function interpolate(
    other:Quaternion, prog:Float
  ):Quaternion {
    return new Quaternion(
         a * (1 - prog) + other.a * prog
        ,b * (1 - prog) + other.b * prog
        ,c * (1 - prog) + other.c * prog
        ,d * (1 - prog) + other.d * prog
      );
  }
  
  /**
The real component of this quaternion.
   */
  public var a:Float;
  
  /**
The coefficient of `i` in this quaternion.
   */
  public var b:Float;
  
  /**
The coefficient of `j` in this quaternion.
   */
  public var c:Float;
  
  /**
The coefficient of `k` in this quaternion.
   */
  public var d:Float;
  
  /**
The point consisting of the coefficients of the imaginary unit vectors.
   */
  public var point(get, never):Point3DF;
  
  private inline function get_point():Point3DF {
    return new Point3DF(b, c, d);
  }
  
  /**
The length of this quaternion.
   */
  public var length(get, never):Float;
  
  private inline function get_length():Float {
    return Math.sqrt(a * a + b * b + c * c + d * d);
  }
  
  /**
Creates a new quaternion - mathematically, it will be
`a + b * i + c * j + d * k`, where `i`, `j`, and `k` are the mutually orthogonal
imaginary unit vectors.
   */
  public inline function new(a:Float, b:Float, c:Float, d:Float){
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
  }
  
  /**
@return Result of rotating `p` using this quaternion as a versor.
   */
  public inline function rotate(p:Point3DF):Point3DF {
    var q = multiplyC(Quaternion.ofPoint(p));
    q.multiplyM(inverseC());
    return q.point;
  }
  
  /**
@return A copy of this quaternion.
   */
  public inline function clone():Quaternion {
    return new Quaternion(a, b, c, d);
  }
  
  /**
@return A conjugate of this quaternion.
   */
  public inline function conjugateC():Quaternion {
    return new Quaternion(a, -b, -c, -d);
  }
  
  /**
Changes this quaternion into its conjugate.
   */
  public inline function conjugateM():Void {
    b = -b;
    c = -c;
    d = -d;
  }
  
  /**
@return An inverse of this quaternion.
   */
  public inline function inverseC():Quaternion {
    var len = length;
    var conj = conjugateC();
    conj.scaleM(1 / (len * len));
    return conj;
  }
  
  /**
Changes this quaternion into its inverse.
   */
  public inline function inverseM():Void {
    var len = length;
    conjugateM();
    scaleM(1 / (len * len));
  }
  
  /**
@return A quaternion with the same direction as this one, but its length equal
to 1.
   */
  public inline function unitC():Quaternion {
    return scaleC(1 / length);
  }
  
  /**
Scales this quaternion so that its length is 1.
   */
  public inline function unitM():Void {
    scaleM(1 / length);
  }
  
  /**
@return Result of scaling this quaternion by a scalar `factor`.
   */
  public inline function scaleC(x:Float):Quaternion {
    return multiplyC(Quaternion.ofReal(x));
  }
  
  /**
Scales this quaternion by a scalar `factor`.
   */
  public inline function scaleM(x:Float):Quaternion {
    multiplyM(Quaternion.ofReal(x));
  }
  
  /**
@return Result of mulitplying this quaternion with `other`.
   */
  public inline function multiplyC(other:Quaternion):Quaternion {
    return new Quaternion(
         a * other.a - b * other.b - c * other.c - d * other.d
        ,a * other.b + b * other.a + c * other.d - d * other.c
        ,a * other.c - b * other.d + c * other.a + d * other.b
        ,a * other.d + b * other.c - c * other.b + d * other.a
      );
  }
  
  /**
Multiplies this quaternion by `other`.
   */
  public inline function multiplyM(other:Quaternion):Quaternion {
    var na = a * other.a - b * other.b - c * other.c - d * other.d;
    var nb = a * other.b + b * other.a + c * other.d - d * other.c;
    var nc = a * other.c - b * other.d + c * other.a + d * other.b;
    d = a * other.d + b * other.c - c * other.b + d * other.a;
    a = na;
    b = nb;
    c = nc;
  }
}
