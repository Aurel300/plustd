package sk.thenet.bmp;

import haxe.ds.Vector;
import sk.thenet.U;

using sk.thenet.FM;

/**
##Colour##

A wrapper around `UInt` for representing 32-bit ARGB colours. Immutable by
design - all `set` functions return a new colour instead of modifying this one.

A number of default colours are defined.

There are three sets of channel properties available:

 - Integer-based (`Colour.ai`, `Colour.ri`, `Colour.gi`, `Colour.bi`) -
   integer values in the range [0, 255].
 - Float-based (`Colour.af`, `Colour.rf`, `Colour.gf`, `Colour.bf`) - floating
   point values in the range [0, 1].
 - Padded integer-based (`Colour.au`, `Colour.ru`, `Colour.gu`, `Colour.bu`) -
   unsigned integer values in the range [0, 255], bitwise shifted to their
   place in the ARGB scheme. E.g.:
```haxe
    var colour = new Colour(0xAA99FF00);
    trace(colour.ai); // 0xAA
    trace(colour.au); // 0xAA000000
    trace(colour.gi); // 0xFF
    trace(colour.gf); // 1.0
    trace(colour.gu); // 0x0000FF00

```
 */
abstract Colour(UInt) from UInt to UInt {
  public static inline var TRANSPARENT:Colour = 0x00000000;
  public static inline var BLACK      :Colour = 0xFF000000;
  public static inline var WHITE      :Colour = 0xFFFFFFFF;
  public static inline var RED        :Colour = 0xFFFF0000;
  public static inline var GREEN      :Colour = 0xFF00FF00;
  public static inline var BLUE       :Colour = 0xFF0000FF;
  public static inline var CYAN       :Colour = 0xFF00FFFF;
  public static inline var MAGENTA    :Colour = 0xFFFF00FF;
  public static inline var YELLOW     :Colour = 0xFFFFFF00;
  
  /**
Creates a colour from the given string. The string is parsed using
`Std.parseInt`. Ideally, it should be in the format `"0xAARRGGBB"`.
   */
  @:from
  public static inline function fromString(argb:String):Colour {
    return new Colour(Std.parseInt(argb));
  }
  
  /**
Creates a colour from individual ARGB channels, represented as integers in the
range [0, 255].
   */
  public static inline function fromARGBi(a:Int, r:Int, g:Int, b:Int):Colour {
    return new Colour((a << 24) | (r << 16) | (g << 8) | b);
  }
  
  /**
Creates a colour from individual ARGB channels, represented as integer values,
which are clamped to the range [0, 255] before being used.
   */
  public static inline function fromARGBic(a:Int, r:Int, g:Int, b:Int):Colour {
    return fromARGBi(
         a.clampI(0, 255)
        ,r.clampI(0, 255)
        ,g.clampI(0, 255)
        ,b.clampI(0, 255)
      );
  }
  
  /**
Creates a colour from individual ARGB channels, represented as floating point
values in the range [0, 1].
   */
  public static inline function fromARGBf(
    a:Float, r:Float, g:Float, b:Float
  ):Colour {
    return fromARGBi(
         Std.int(a * 255)
        ,Std.int(r * 255)
        ,Std.int(g * 255)
        ,Std.int(b * 255)
      );
  }
  
  /**
Creates a colour from individual ARGB channels, represented as floating point
values, which are clamped to the range [0, 1] before being used.
   */
  public static inline function fromARGBfc(
    a:Float, r:Float, g:Float, b:Float
  ):Colour {
    return fromARGBi(
         Std.int(a * 255).clampI(0, 255)
        ,Std.int(r * 255).clampI(0, 255)
        ,Std.int(g * 255).clampI(0, 255)
        ,Std.int(b * 255).clampI(0, 255)
      );
  }
  
  public static function fromHSLf(
    h:Float, s:Float, l:Float
  ):Colour {
    if (s <= 0) {
      return fromARGBf(1, l, l, l);
    }
    function hue2rgb(p:Float, q:Float, t:Float) {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    }
    var q:Float = l < 0.5 ? l * (1 + s) : l + s - l * s;
    var p:Float = 2 * l - q;
    return fromARGBf(
         1
        ,hue2rgb(p, q, h + 1 / 3)
        ,hue2rgb(p, q, h)
        ,hue2rgb(p, q, h - 1 / 3)
      );
  }
  
  public static function distance(c1:Colour, c2:Colour):Int {
    return FM.absI(c1.ri - c2.ri)
      + FM.absI(c1.gi - c2.gi)
      + FM.absI(c1.bi - c2.bi);
  }
  
  public static function quantise(c:Colour, pal:Vector<Colour>):Int {
    var bestI    = 0;
    var bestDist = distance(c, pal[0]);
    for (i in 1...pal.length) {
      var dist = distance(c, pal[1]);
      if (dist < bestDist) {
        bestI = i;
        bestDist = dist;
      }
    }
    return bestI;
  }
  
  /**
Creates a colour from a 32-bit unsigned integer in the format 0xAARRGGBB.
   */
  public inline function new(colour:UInt) {
    this = colour;
  }
  
  /**
Converts the colour to a string in the format: `0xAARRGGBB`.
   */
  @:to
  public inline function toStringHex():String {
    return "0x" + U.hex2(ai) + U.hex2(ri) + U.hex2(gi) + U.hex2(bi);
  }
  
  /**
Blends this colour over `dest` using the alpha blending algorithm.
   */
  public inline function blendWith(dest:Colour):Colour {
    return (dest.ai == 255
      ? Colour.fromARGBf(
             1
            ,rf * af + dest.rf * (1 - af)
            ,gf * af + dest.gf * (1 - af)
            ,bf * af + dest.bf * (1 - af)
          )
      : (dest.ai == 0 && ai == 0
        ? 0
        : {
            var dstaf = dest.af * (1 - af);
            var outaf = af + dstaf;
            Colour.fromARGBf(
                 outaf
                ,(rf * af + dest.rf * dstaf) / outaf
                ,(gf * af + dest.gf * dstaf) / outaf
                ,(bf * af + dest.bf * dstaf) / outaf
              );
          }));
  }
  
  /**
Padded integer-based alpha channel of this colour.
   */
  public var au(get, never):UInt;
  
  private inline function get_au():UInt {
    return this & 0xFF000000;
  }
  
  /**
@return A new colour copied from this one, but with its `au` set to `val`.
   */
  public inline function setAu(val:UInt):Colour {
    return (this & 0xFFFFFF) | val;
  }
  
  /**
Padded integer-based red channel of this colour.
   */
  public var ru(get, never):UInt;
  
  private inline function get_ru():UInt {
    return this & 0xFF0000;
  }
  
  /**
@return A new colour copied from this one, but with its `ru` set to `val`.
   */
  public inline function setRu(val:UInt):Colour {
    return (this & 0xFF00FFFF) | val;
  }
  
  /**
Padded integer-based green channel of this colour.
   */
  public var gu(get, never):UInt;
  
  private inline function get_gu():UInt {
    return this & 0xFF00;
  }
  
  /**
@return A new colour copied from this one, but with its `gu` set to `val`.
   */
  public inline function setGu(val:UInt):Colour {
    return (this & 0xFFFF00FF) | val;
  }
  
  /**
Padded integer-based blue channel of this colour.
   */
  public var bu(get, never):UInt;
  
  private inline function get_bu():UInt {
    return this & 0xFF;
  }
  
  /**
@return A new colour copied from this one, but with its `bu` set to `val`.
   */
  public inline function setBu(val:UInt):Colour {
    return (this & 0xFFFFFF00) | val;
  }
  
  /**
Integer-based alpha channel of this colour.
   */
  public var ai(get, never):Int;
  
  private inline function get_ai():Int {
    return this >> 24;
  }
  
  /**
@return A new colour copied from this one, but with its `ai` set to `val`.
   */
  public inline function setAi(val:Int):Colour {
    return (this & 0xFFFFFF) | (val << 24);
  }
  
  /**
Integer-based red channel of this colour.
   */
  public var ri(get, never):Int;
  
  private inline function get_ri():Int {
    return (this >> 16) & 0xFF;
  }
  
  /**
@return A new colour copied from this one, but with its `ri` set to `val`.
   */
  public inline function setRi(val:Int):Colour {
    return (this & 0xFF00FFFF) | (val << 16);
  }
  
  /**
Integer-based green channel of this colour.
   */
  public var gi(get, never):Int;
  
  private inline function get_gi():Int {
    return (this >> 8) & 0xFF;
  }
  
  /**
@return A new colour copied from this one, but with its `gi` set to `val`.
   */
  public inline function setGi(val:Int):Colour {
    return (this & 0xFFFF00FF) | (val << 8);
  }
  
  /**
Integer-based blue channel of this colour.
   */
  public var bi(get, never):Int;
  
  private inline function get_bi():Int {
    return this & 0xFF;
  }
  
  /**
@return A new colour copied from this one, but with its `bi` set to `val`.
   */
  public inline function setBi(val:Int):Colour {
    return (this & 0xFFFFFF00) | val;
  }
  
  /**
Float-based alpha channel of this colour.
   */
  public var af(get, never):Float;
  
  private inline function get_af():Float {
    return ai / 255;
  }
  
  /**
@return A new colour copied from this one, but with its `af` set to `val`.
   */
  public inline function setAf(val:Float):Colour {
    return setAi(Std.int(val * 255));
  }
  
  /**
@return A new colour copied from this one, but with its `af` set to `val * af`.
   */
  public inline function mulAf(val:Float):Colour {
    return setAi(Std.int(ai * val));
  }
  
  /**
Float-based red channel of this colour.
   */
  public var rf(get, never):Float;
  
  private inline function get_rf() {
    return ri / 255;
  }
  
  /**
@return A new colour copied from this one, but with its `rf` set to `val`.
   */
  public inline function setRf(val:Float):Colour {
    return setRi(Std.int(val * 255));
  }
  
  /**
Float-based green channel of this colour.
   */
  public var gf(get, never):Float;
  
  private inline function get_gf() {
    return gi / 255;
  }
  
  /**
@return A new colour copied from this one, but with its `gf` set to `val`.
   */
  public inline function setGf(val:Float):Colour {
    return setGi(Std.int(val * 255));
  }
  
  /**
Float-based blue channel of this colour.
   */
  public var bf(get, never):Float;
  
  private inline function get_bf() {
    return bi / 255;
  }
  
  /**
@return A new colour copied from this one, but with its `bf` set to `val`.
   */
  public inline function setBf(val:Float):Colour {
    return setBi(Std.int(val * 255));
  }
  
  public var rgba(get, never):UInt;
  
  private inline function get_rgba():UInt {
    return ((this & 0xFFFFFF) << 8) | (this >>> 24);
  }
}
