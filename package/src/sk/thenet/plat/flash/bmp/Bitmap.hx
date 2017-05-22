package sk.thenet.plat.flash.bmp;

#if flash

import haxe.ds.Vector;
import flash.display.BitmapData;
import sk.thenet.FM;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.FluentBitmap;

/**
Flash implementation of `sk.thenet.bmp.IBitmap`.

@see `sk.thenet.bmp.IBitmap`
 */
@:allow(sk.thenet.plat.flash)
class Bitmap implements sk.thenet.bmp.IBitmap {
  public var height(default, null):Int;
  
  public var width(default, null):Int;
  
  public var fluent(get, never):FluentBitmap;
  
  public inline function get_fluent():FluentBitmap {
    return new FluentBitmap(this);
  }
  
  private var native:BitmapData;
  
  private function new(native:BitmapData){
    this.native = native;
    width = native.width;
    height = native.height;
  }
  
  public function debug():Void {
    var b = new flash.display.Bitmap(native);
    flash.Lib.current.addChild(b);
  }
  
  public inline function get(x:Int, y:Int):Colour {
    return native.getPixel32(x, y);
  }
  
  public inline function set(x:Int, y:Int, colour:Colour):Void {
    native.setPixel32(x, y, colour);
  }
  
  public inline function getVector():Vector<Colour> {
    return (cast native.getVector(native.rect):Vector<Colour>);
  }
  
  public inline function setVector(vector:Vector<Colour>):Void {
    native.setVector(native.rect, (cast vector:flash.Vector<UInt>));
  }
  
  public function getVectorRect(
    x:Int, y:Int, width:Int, height:Int
  ):Vector<Colour> {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    return (cast native.getVector(
        new flash.geom.Rectangle(x, y, width, height)
      ):Vector<Colour>);
  }
  
  public function setVectorRect(
    x:Int, y:Int, width:Int, height:Int, vector:Vector<Colour>
  ):Void {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    native.setVector(
        new flash.geom.Rectangle(x, y, width, height),
        (cast vector:flash.Vector<UInt>)
      );
  }
  
  public inline function fill(colour:Colour):Void {
    native.fillRect(native.rect, colour);
  }
  
  public inline function fillRect(
    x:Int, y:Int, width:Int, height:Int, colour:Colour
  ):Void {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    native.fillRect(new flash.geom.Rectangle(x, y, width, height), colour);
  }
  
  public inline function blit(src:Bitmap, x:Int, y:Int):Void {
    native.copyPixels(
         src.native, src.native.rect
        ,new flash.geom.Point(x, y), null, null, false
      );
  }
  
  public inline function blitRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void {
    native.copyPixels(
         src.native, new flash.geom.Rectangle(srcX, srcY, srcW, srcH)
        ,new flash.geom.Point(dstX, dstY), null, null, false
      );
  }
  
  public inline function blitAlpha(src:Bitmap, x:Int, y:Int):Void {
    native.copyPixels(
         src.native, src.native.rect
        ,new flash.geom.Point(x, y), null, null, true
      );
  }
  
  public inline function blitAlphaRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void {
    native.copyPixels(
         src.native, new flash.geom.Rectangle(srcX, srcY, srcW, srcH)
        ,new flash.geom.Point(dstX, dstY), null, null, true
      );
  }
}

#end
