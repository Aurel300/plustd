package sk.thenet;

import sk.thenet.stream.prng.Generator;
import sk.thenet.stream.prng.XORShift;

/**
##Fast Math: optimised math methods##

Currently the rounding functions are optimised for the flash target. Anything
else should be faster or as fast as the basic Math.* functions.

Some functions are suffixed with `F` or `I`, for `Float` and `Int` arguments.

####Important note on the `ceilZ` and `floorZ` functions:####

`ceilZ` takes a number and returns the nearest integer farther from 0. This is
inconsistent with the standard `Math.ceil`.

```haxe
Math.ceil(-2.5) == -2
FM.ceil(-2.5) == -2
FM.ceilZ(-2.5) == -3
```

Likewise, `floor` returns the the nearest integer closer to 0.

```haxe
Math.floor(-2.5) == -3
FM.floor(-2.5) == -3
FM.floorZ(-2.5) == -2
```

However, if you know that your inputs are definitely positive, `ceilZ` and
`floorZ` might be faster.
 */
class FM {
  /**
Shorthand for a pseudo-random number generator. Initialised by default to
`sk.thenet.stream.prng.XORShift` with a seed of `0xFAB74573`.
   */
  public static var prng:Generator = new Generator(new XORShift(0xFAB74573));
  
  /**
@return Absolute value of `x`.
   */
  public static inline function absF(x:Float):Float {
    return x < 0 ? -x : x;
  }
  
  /**
@return Absolute value of `x`.
   */
  public static inline function absI(x:Int):Int {
    return (x ^ (x >> 31)) - (x >> 31);
  }
  
  /**
@return `1` if `x` is positive, `-1` if `x` is negative, `0` otherwise.
  */
  public static inline function signF(x:Float):Int {
    return (x == 0 ? 0 : (x < 1 ? -1 : 1));
  }
  
  /**
@return `1` if `x` is positive, `-1` if `x` is negative, `0` otherwise.
  */
  public static inline function signI(x:Int):Int {
    return (x == 0 ? 0 : (x < 1 ? -1 : 1));
  }
  
  /**
@return `x`, rounded up to the nearest integer.
   */
  public static inline function ceil(x:Float):Int {
#if flash
    return (x < 0 ? untyped __global__["int"](x) : untyped __global__["int"](x) + 1);
#else
    return Math.ceil(x);
#end
  }
  
  /**
See above for note on `ceilZ` and `floorZ`.

@return `x`, rounded to the nearest integer further from 0.
   */
  public static inline function ceilZ(x:Float):Int {
#if flash
    return untyped __global__["int"](x + 1);
#else
    return Math.ceil(x);
#end
  }
  
  /**
@return Clamps `x` between `min` and `max` such that `clamped` >= `min`
and `clamped` <= `max`.
   */
  public static inline function clampF(x:Float, min:Float, max:Float):Float {
    return (x < min ? min : (x > max ? max : x));
  }
  
  /**
@return Clamps `x` between `min` and `max` such that `clamped` >= `min`
and `clamped` <= `max`.
   */
  public static inline function clampI(x:Int, min:Int, max:Int):Int {
    return (x < min ? min : (x > max ? max : x));
  }
  
  /**
@return `x`, rounded down to the nearest integer.
   */
  public static inline function floor(x:Float):Int {
#if flash
    return (x < 0 ? untyped __global__["int"](x) - 1 : untyped __global__["int"](x));
#else
    return Math.floor(x);
#end
  }
  
  /**
See above for note on `ceilZ` and `floorZ`.

@return `x`, rounded to the nearest integer closer to zero.
   */
  public static inline function floorZ(x:Float):Int {
    return Std.int(x);
  }
  
  /**
@return The fractional part of `x`.
   */
  public static inline function frac(x:Float):Float {
#if flash
    return x - (untyped __global__["int"](x));
#else
    return x - Math.floor(x);
#end
  }
  
  /**
@return `true` iff `x` is negative.
   */
  public static inline function isNegI(x:Int):Bool {
    return (x >>> 31) != 0;
  }
  
  /**
@return The bigger number among `x` and `y`.
   */
  public static inline function maxF(x:Float, y:Float):Float {
    return x > y ? x : y;
  }
  
  /**
@return The bigger number among `x` and `y`.
   */
  public static inline function maxI(x:Int, y:Int):Int {
    return x > y ? x : y;
  }
  
  /**
@return The smaller number among `x` and `y`.
   */
  public static inline function minF(x:Float, y:Float):Float {
    return x < y ? x : y;
  }
  
  /**
@return The smaller number among `x` and `y`.
   */
  public static inline function minI(x:Int, y:Int):Int {
    return x < y ? x : y;
  }
  
  /**
@return `n` if `pos && !neg`, `-n` if `!pos && neg`, `0` otherwise.
   */
  public static inline function negposI(n:Int, neg:Bool, pos:Bool):Int {
    return neg != pos ? (neg ? -n : n) : 0;
  }
  
  /**
@return `n` if `pos && !neg`, `-n` if `!pos && neg`, `0` otherwise.
   */
  public static inline function negposF(n:Float, neg:Bool, pos:Bool):Float {
    return neg != pos ? (neg ? -n : n) : 0;
  }
  
  public static inline function nmodI(n:Int, mod:Int):Int {
    return (n < 0 ? mod - ((-n) % mod) : n) % mod;
  }
  
  public static inline function nmodF(n:Float, mod:Float):Float {
    return (n < 0 ? mod - ((-n) % mod) : n) % mod;
  }
  
  /**
@return `x`, rounded to the nearest integer.
   */
  public static inline function round(x:Float):Int {
#if flash
    return untyped __global__["int"](x + .5);
#else
    return Math.floor(x + .5);
#end
  }
  
  /**
@return Degree equivalent of `rad` radians.
   */
  public static inline function deg(rad:Float):Float {
    return (rad / Math.PI) * 180;
  }
  
  /**
@return Radian equivalent of `deg` degrees.
   */
  public static inline function rad(deg:Float):Float {
    return (deg / 180) * Math.PI;
  }
  
  /**
@return `true` iff `x` >= `min` and `x` <= `max`.
   */
  public static inline function withinF(x:Float, min:Float, max:Float):Bool {
    return x >= min && x <= max;
  }
  
  /**
@return `true` iff `x` >= `min` and `x` <= `max`.
   */
  public static inline function withinI(x:Int, min:Int, max:Int):Bool {
    return x >= min && x <= max;
  }
}
