package sk.thenet.anim;

import sk.thenet.FM;

/**
##Timing function##

This is a wrapper for functions which can act as timing functions. Functions
which take inputs in `[0, 1]` and generally output values in `[0, 1]`, ensuring
that the inputs `0` and `1` are mapped to the same number, qualify as timing
functions (although this assertion is not made in code).

A couple of standard timing functions are also provided.
 */
@:callable
abstract Timing(Float->Float) from (Float->Float) to (Float->Float) {
  public static var linear(default, null):Timing
    = function(x) return x;
  public static var quadIn(default, null):Timing
    = function(x) return x * x;
  public static var quadOut(default, null):Timing
    = function(x) return -x * (x - 2);
  public static var quadInOut(default, null):Timing
    = function(x) return (x < .5
      ? 2 * x * x
      : -.5 * (x = 2 * x - 2) * x + 1);
  public static var cubicIn(default, null):Timing
    = function(x) return x * x * x;
  public static var cubicOut(default, null):Timing
    = function(x) return (--x) * x * x + 1;
  public static var cubicInOut(default, null):Timing
    = function(x) return (x < .5
      ? 4 * x * x * x
      : .5 * (x = 2 * x - 2) * x * x + 1);
  public static var quartIn(default, null):Timing
    = function(x) return x * x * x * x;
  public static var quartOut(default, null):Timing
    = function(x) return -(--x) * x * x * x + 1;
  public static var quartInOut(default, null):Timing
    = function(x) return (x < .5
      ? 8 * x * x * x * x
      : -.5 * (x = 2 * x - 2) * x * x * x + 1);
  public static var quintIn(default, null):Timing
    = function(x) return x * x * x * x * x;
  public static var quintOut(default, null):Timing
    = function(x) return (--x) * x * x * x * x + 1;
  public static var quintInOut(default, null):Timing
    = function(x) return (x < .5
      ? 16 * x * x * x * x * x
      : .5 * (x = 2 * x - 2) * x * x * x * x + 1);
  public static var sineIn(default, null):Timing
    = function(x) return -Math.cos(x * Math.PI * .5) + 1;
  public static var sineOut(default, null):Timing
    = function(x) return Math.sin(x * Math.PI * .5);
  public static var sineInOut(default, null):Timing
    = function(x) return -.5 * Math.cos(x * Math.PI) + .5;
  public static var expoIn(default, null):Timing
    = function(x) return (x == 0 ? 0 : Math.pow(2, 10 * x - 10));
  public static var expoOut(default, null):Timing
    = function(x) return (x == 1 ? 1 : -Math.pow(2, -10 * x) + 1);
  public static var expoInOut(default, null):Timing
    = function(x) return (x == 0 || x == 1 ? x : (x < .5
      ? .5 * Math.pow(2, 20 * x - 10)
      : .5 * -Math.pow(2, -20 * x + 10) + 1));
  public static var circIn(default, null):Timing
    = function(x) return -Math.sqrt(1 - x * x) + 1;
  public static var circOut(default, null):Timing
    = function(x) return Math.sqrt(1 - (--x) * x);
  public static var circInOut(default, null):Timing
    = function(x) return (x < .5
      ? -.5 * Math.sqrt(1 - 4 * x * x - 1)
      : .5 * Math.sqrt(1 - (x = 2 * x - 2) * x) + 1);
  
  public inline function new(func:Float->Float){
    this = func;
  }
  
  public inline function getF(pos:Float):Float {
    return this(FM.clampF(pos, 0, 1));
  }
  
  public inline function getI(pos:Float, max:Int):Int {
    return FM.round(getF(pos) * max);
  }
}
