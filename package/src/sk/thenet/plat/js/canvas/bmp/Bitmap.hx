package sk.thenet.plat.js.canvas.bmp;

#if js

import haxe.ds.Vector;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import sk.thenet.FM;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.FluentBitmap;

/**
JavaScript / Canvas implementation of `sk.thenet.bmp.IBitmap`.

@see `sk.thenet.bmp.IBitmap`
 */
@:allow(sk.thenet.plat.js)
class Bitmap implements sk.thenet.bmp.IBitmap {
  public var height(default, null):Int;
  
  public var width(default, null):Int;
  
  public var fluent(get, never):FluentBitmap;
  
  public inline function get_fluent():FluentBitmap {
    return new FluentBitmap(this);
  }
  
  private var native:CanvasElement;
  private var c2d:CanvasRenderingContext2D;
  
  public var data:Vector<Colour>;
  private var size32:Int;
  private var size8:Int;
  public var changed:Bool;
  
  private function new(native:CanvasElement){
    this.native = native;
    width = native.width;
    height = native.height;
    c2d = native.getContext2d();
    c2d.imageSmoothingEnabled = false;
    untyped __js__("this.c2d.webkitImageSmoothingEnabled = false");
    untyped __js__("this.c2d.msImageSmoothingEnabled = false");
    untyped __js__("this.c2d.mozImageSmoothingEnabled = false");
    //fill(nfc);
    data = new Vector<Colour>(width * height);
    size32 = width * height;
    size8 = size32 << 2;
    data = getVector();
    changed = false;
  }
  
  public inline function get(x:Int, y:Int):UInt {
    getVector();
    if (!FM.withinI(x, 0, width - 1) || !FM.withinI(y, 0, height - 1)){
      return 0;
    }
    return data[x + y * width];
  }
  
  public inline function set(x:Int, y:Int, colour:Colour):Void {
    fillRect(x, y, 1, 1, colour);
    changed = true;
  }
  
  public inline function getVector():Vector<Colour> {
    if (changed){
      var data8 = c2d.getImageData(0, 0, width, height).data;
      var j:Int = 0;
      for (i in 0...size32){
        data[i]
          = (data8[j + 3] << 24)
          | (data8[j    ] << 16)
          | (data8[j + 1] << 8 )
          | (data8[j + 2]      );
        j += 4;
      }
      changed = false;
    }
    return data;
  }
  
  public inline function setVector(vector:Vector<Colour>):Void {
		//data = v;
		//var idata = c2d.createImageData(width, height);
		//var data8 = idata.data;
		var data8 = new js.html.Uint8ClampedArray(size8);
		var j:Int = 0;
		for (i in 0...size32){
			data8[j] = (data[i] >>> 16) & 0xFF;
			data8[j + 1] = (data[i] >>> 8) & 0xFF;
			data8[j + 2] = data[i] & 0xFF;
			data8[j + 3] = data[i] >>> 24;
			//untyped __js__("debugger");
			j += 4;
		}
		//trace(data8);
		var idata = new js.html.ImageData(width, height);
		idata.data.set(data8);
		//untyped __js__("idata.data.set(data8)");
		//untyped __js__("debugger");
		c2d.putImageData(idata, 0, 0, 0, 0, width, height);
		changed = true;
		//changed = true;
		//getFullVector();
  }
  
  public function getVectorRect(
    x:Int, y:Int, width:Int, height:Int
  ):Vector<UInt> {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - x);
    return null;
  }
  
  public function setVectorRect(
    x:Int, y:Int, width:Int, height:Int, vector:Vector<Colour>
  ):Void {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - x);
    
  }
  
  public inline function fill(colour:Colour):Void {
    fillRect(0, 0, width, height, colour);
  }
  
  public inline function fillRect(
    x:Int, y:Int, width:Int, height:Int, colour:Colour
  ):Void {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - x);
    inline function colourToDOM(c:Colour):String {
      return 'rgba(${c.ri}, ${c.gi}, ${c.bi}, ${c.af})';
    }
    c2d.fillStyle = colourToDOM(colour);
    c2d.fillRect(x, y, width, height);
    changed = true;
  }
  
  public inline function blitAlpha(src:Bitmap, x:Int, y:Int):Void {
    c2d.drawImage(
        src.native, 0, 0, src.width, src.height, x, y, src.width, src.height
      );
    changed = true;
  }
  
  public inline function blitAlphaRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void {
    c2d.drawImage(src.native, srcX, srcY, srcW, srcH, dstX, dstY, srcW, srcH);
    changed = true;
  }
}

#end
