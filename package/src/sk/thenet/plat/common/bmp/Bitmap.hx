package sk.thenet.plat.common.bmp;

#if (PLUSTD_TARGET == "neko")

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.FluentBitmap;

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
  
  public inline function get_fluent():FluentBitmap {
    return new FluentBitmap(this);
  }
  
  private var native:Vector<Colour>;
  
  private function new(width:Int, height:Int, colour:Colour){
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
    return native;
  }
  
  public inline function setVector(vector:Vector<Colour>):Void {
    native = vector;
  }
  
  public function getVectorRect(
    x:Int, y:Int, width:Int, height:Int
  ):Vector<UInt> {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    return null;
  }
  
  public function setVectorRect(
    x:Int, y:Int, width:Int, height:Int, vector:Vector<Colour>
  ):Void {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    
  }
  
  public inline function fill(colour:Colour):Void {
    for (i in 0...native.length){
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
    
  }
  
  public inline function blit(src:Bitmap, x:Int, y:Int):Void {
    
  }
  
  public inline function blitRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void {
    
  }
  
  public inline function blitAlpha(src:Bitmap, x:Int, y:Int):Void {
    
  }
  
  public inline function blitAlphaRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void {
    
  }
}

#end
