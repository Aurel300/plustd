package sk.thenet.plat.common.bmp;

#if (PLUSTD_TARGET == "neko")

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.FluentBitmap;

using sk.thenet.FM;

/**
Haxe implementation of `sk.thenet.bmp.IBitmap`.

(Very much unfinished!)

@see `sk.thenet.bmp.IBitmap`
 */
@:allow(sk.thenet.plat)
class Bitmap implements sk.thenet.bmp.IBitmap {
  public var height(default, null):Int;
  
  public var width(default, null):Int;
  
  public var fluent(get, never):FluentBitmap;
  
  private inline function get_fluent():FluentBitmap {
    return new FluentBitmap(this);
  }
  
  private var native:Vector<Colour>;
  
  private function new(width:Int, height:Int, colour:Colour) {
    native = new Vector<Colour>(width * height);
    this.width = width;
    this.height = height;
    fill(colour);
  }
  
  public inline function get(x:Int, y:Int):Colour {
    return native[x + y * width];
  }
  
  public inline function set(x:Int, y:Int, colour:Colour):Void {
    native[x + y * width] = colour;
  }
  
  public inline function getVector():Vector<Colour> {
    return native.copy();
  }
  
  public inline function setVector(vector:Vector<Colour>):Void {
    Vector.blit(vector, 0, native, 0, native.length);
  }
  
  public function getVectorRect(
    x:Int, y:Int, width:Int, height:Int
  ):Vector<Colour> {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    var ret = new Vector<Colour>(width * height);
    var ri = 0;
    for (oy in 0...height) for (ox in 0...width) {
      ret[ri] = native[(x + ox) + (y + oy) * this.width];
      ri++;
    }
    return ret;
  }
  
  public function setVectorRect(
    x:Int, y:Int, width:Int, height:Int, vector:Vector<Colour>
  ):Void {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    var ri = 0;
    for (oy in 0...height) for (ox in 0...width) {
      native[(x + ox) + (y + oy) * this.width] = vector[ri];
      ri++;
    }
  }
  
  public inline function fill(colour:Colour):Void {
    for (i in 0...native.length) {
      native[i] = colour;
    }
  }
  
  public inline function fillRect(
    x:Int, y:Int, width:Int, height:Int, colour:Colour
  ):Void {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    for (oy in 0...height) for (ox in 0...width) {
      native[(x + ox) + (y + oy) * this.width] = colour;
    }
  }
  
  public inline function blit(src:Bitmap, x:Int, y:Int):Void {
    for (oy in y.maxI(0)...(y + src.height).minI(height - 1)) {
      for (ox in x.maxI(0)...(x + src.width).minI(width - 1)) {
        native[ox + oy * this.width] = src.native[(ox - x) + (oy - y) * src.width];
      }
    }
  }
  
  public inline function blitRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void {
    for (oy in dstY.maxI(0)...(dstY + srcH).minI(height - 1)) {
      for (ox in dstY.maxI(0)...(dstX + srcW).minI(width - 1)) {
        native[ox + oy * this.width] = src.native[(ox - dstX) + (oy - dstY) * src.width];
      }
    }
  }
  
  public inline function blitAlpha(src:Bitmap, x:Int, y:Int):Void {
    for (oy in y.maxI(0)...(y + src.height).minI(height - 1)) {
      for (ox in x.maxI(0)...(x + src.width).minI(width - 1)) {
        native[ox + oy * this.width] = src.native[(ox - x) + (oy - y) * src.width].blendWith(native[ox + oy * this.width]);
      }
    }
  }
  
  public inline function blitAlphaRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void {
    for (oy in dstY.maxI(0)...(dstY + srcH).minI(height - 1)) {
      for (ox in dstY.maxI(0)...(dstX + srcW).minI(width - 1)) {
        native[ox + oy * this.width] = src.native[(ox - dstX) + (oy - dstY) * src.width].blendWith(native[ox + oy * this.width]);
      }
    }
  }
}

#end
