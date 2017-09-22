package sk.thenet.audio.minimod;

import haxe.ds.Vector;

using sk.thenet.FM;

class InstrumentTools {
  public static function fadeIn(a:Vector<Float>, length:Int):Vector<Float> {
    for (i in 0...length.minI(a.length)) {
      a[i] *= i / length;
    }
    return a;
  }
  
  public static function fadeOut(a:Vector<Float>, length:Int):Vector<Float> {
    for (i in 0...length.minI(a.length)) {
      a[a.length - i - 1] *= i / length;
    }
    return a;
  }
  
  public static function pad(a:Vector<Float>, length:Int):Vector<Float> {
    var ret = new Vector<Float>(a.length + length);
    Vector.blit(a, 0, ret, 0, a.length);
    for (i in a.length...a.length + length) {
      ret[i] = 0;
    }
    return ret;
  }
  
  public static function prepareA(a:Array<Float>):Vector<Float> {
    return prepareV(Vector.fromArrayCopy(a));
  }
  
  public static function prepareV(a:Vector<Float>):Vector<Float> {
    return fadeOut(fadeIn(pad(a, Minimod.SAMPLES), 100), 100);
  }
  
  public static inline function inv(a:Float):Float {
    return 1 - a;
  }
  
  public static inline function sin(a:Float):Float {
    return Math.sin(a * Math.PI * 2);
  }
  
  public static inline function saw(a:Float):Float {
    return a * 2 - 1;//;(a < .5 ? a * 4 - 1 : (a - .5) * 4 - 1);
  }
  
  public static inline function tri(a:Float):Float {
    return (a < .5 ? a * 4 - 1 : -((-a + .75) * 4 - 1));
  }
  
  public static inline function pwm(a:Float, i:Int):Float {
    return (a < sin(i / 50000) * .2 + .5 ? -1 : 1);
  }
  
  public static inline function s2f<T:Float>(i:T, f:Float):Float {
    return ((i / 44100) * f) % 1.0;
  }
}
