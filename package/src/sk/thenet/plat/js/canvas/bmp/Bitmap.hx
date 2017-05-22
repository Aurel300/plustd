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
  
  private inline function get_fluent():FluentBitmap {
    return new FluentBitmap(this);
  }
  
  private var native:CanvasElement;
  private var c2d:CanvasRenderingContext2D;
  
  public var data:Vector<Colour>;
  private var size32:Int;
  private var size8:Int;
  public var changed:Bool;
  
  private function new(native:CanvasElement, ?c2d:CanvasRenderingContext2D){
    this.native = native;
    width = native.width;
    height = native.height;
    if (c2d != null){
      this.c2d = c2d;
    } else {
      this.c2d = native.getContext2d();
    }
    this.c2d.imageSmoothingEnabled = false;
    untyped __js__("{0}.webkitImageSmoothingEnabled = false", this.c2d);
    untyped __js__("{0}.msImageSmoothingEnabled = false", this.c2d);
    untyped __js__("{0}.mozImageSmoothingEnabled = false", this.c2d);
    data = new Vector<Colour>(width * height);
    size32 = width * height;
    size8 = size32 << 2;
    changed = true;
    getVector();
  }
  
  public function debug():Void {
    js.Browser.document.body.appendChild(native);
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
      var j = 0;
      for (i in 0...size32){
        data[i] = Colour.fromARGBi(
            data8[j + 3], data8[j], data8[j + 1], data8[j + 2]
          );
        j += 4;
      }
      changed = false;
    }
    return data;
  }
  
  public inline function setVector(vector:Vector<Colour>):Void {
    data = vector;
    var data8 = new js.html.Uint8ClampedArray(size8);
    var j = 0;
    for (i in 0...size32){
      data8[j    ] = data[i].ri;
      data8[j + 1] = data[i].gi;
      data8[j + 2] = data[i].bi;
      data8[j + 3] = data[i].ai;
      j += 4;
    }
    var idata = new js.html.ImageData(width, height);
    idata.data.set(data8);
    c2d.putImageData(idata, 0, 0, 0, 0, width, height);
    changed = false;
  }
  
  public function getVectorRect(
    x:Int, y:Int, width:Int, height:Int
  ):Vector<UInt> {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    getVector();
    var ret = new Vector<Colour>(width * height);
    var vi = 0;
    var di = 0;
    for (vy in y...y + height){
      di = x + vy * this.width;
      for (vx in x...x + width){
        ret[vi] = data[di];
        vi++;
        di++;
      }
    }
    return ret;
  }
  
  public function setVectorRect(
    x:Int, y:Int, width:Int, height:Int, vector:Vector<Colour>
  ):Void {
    getVector();
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    var data8 = new js.html.Uint8ClampedArray(width * height * 4);
    var vi = 0;
    var di = 0;
    for (vy in y...y + height){
      di = x + vy * this.width;
      for (vx in x...x + width){
        data[di] = vector[vi];
        data8[(di << 2)    ] = data[di].ri;
        data8[(di << 2) + 1] = data[di].gi;
        data8[(di << 2) + 2] = data[di].bi;
        data8[(di << 2) + 3] = data[di].ai;
        vi++;
        di++;
      }
    }
    var idata = new js.html.ImageData(width, height);
    idata.data.set(data8);
    c2d.putImageData(idata, x, y, 0, 0, width, height);
    changed = false;
  }
  
  public inline function fill(colour:Colour):Void {
    fillRect(0, 0, width, height, colour);
  }
  
  public inline function fillRect(
    x:Int, y:Int, width:Int, height:Int, colour:Colour
  ):Void {
    /*
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    */
    if (colour.ai != 255){
      c2d.clearRect(x, y, width, height);
    }
    setFillColour(colour);
    c2d.fillRect(x, y, width, height);
    changed = true;
  }
  
  public inline function setFillColour(c:Colour):Void {
    c2d.fillStyle = 'rgba(${c.ri},${c.gi},${c.bi},${c.af})';
  }
  
  public inline function toFillPattern():js.html.CanvasPattern {
    return c2d.createPattern(native, "repeat");
  }
  
  public inline function setFillPattern(pattern:js.html.CanvasPattern):Void {
    c2d.fillStyle = pattern;
  }
  
  public inline function fillRectStyled(
    x:Int, y:Int, width:Int, height:Int
  ):Void {
    c2d.fillRect(x, y, width, height);
  }
  
  public inline function fillRectAlpha(
    x:Int, y:Int, width:Int, height:Int, colour:Colour
  ):Void {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    inline function colourToDOM(c:Colour):String {
      return 'rgba(${c.ri}, ${c.gi}, ${c.bi}, ${c.af})';
    }
    c2d.fillStyle = colourToDOM(colour);
    c2d.fillRect(x, y, width, height);
    changed = true;
  }
  
  public inline function blit(src:Bitmap, x:Int, y:Int):Void {
    c2d.clearRect(x, y, src.width, src.height);
    c2d.drawImage(
        src.native, 0, 0, src.width, src.height, x, y, src.width, src.height
      );
    changed = true;
  }
  
  public inline function blitRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void {
    if (srcW <= 0 || srcH <= 0){
      return;
    }
    c2d.clearRect(dstX, dstY, src.width, src.height);
    c2d.drawImage(src.native, srcX, srcY, srcW, srcH, dstX, dstY, srcW, srcH);
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
    if (srcW <= 0 || srcH <= 0){
      return;
    }
    c2d.drawImage(src.native, srcX, srcY, srcW, srcH, dstX, dstY, srcW, srcH);
    changed = true;
  }
}

#end
