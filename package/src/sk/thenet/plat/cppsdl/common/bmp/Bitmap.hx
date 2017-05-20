package sk.thenet.plat.cppsdl.common.bmp;

#if cpp

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.FluentBitmap;
import sk.thenet.plat.cppsdl.common.SDL;
import sk.thenet.plat.cppsdl.common.SDL.RendererPointer;
import sk.thenet.plat.cppsdl.common.SDL.SurfacePointer;
import sk.thenet.plat.cppsdl.common.SDL.TexturePointer;
import sk.thenet.plat.cppsdl.common.SDL.WindowPointer;

/**
C++ / SDL implementation of `sk.thenet.bmp.IBitmap`.

@see `sk.thenet.bmp.IBitmap`
 */
@:allow(sk.thenet.plat.cppsdl)
@:build(sk.thenet.plat.cppsdl.common.SDLMacro.slave("../"))
class Bitmap implements sk.thenet.bmp.IBitmap {
  public var height(default, null):Int;
  
  public var width(default, null):Int;
  
  public var fluent(get, never):FluentBitmap;
  
  public inline function get_fluent():FluentBitmap {
    return new FluentBitmap(this);
  }
  
  public var main:Bool;
  public var scale:Int;
  public var tex:TexturePointer;
  
  private var wh:Int;
  private var whpix:Int;
  
  private function new(
     width:Int, height:Int, ?tex:TexturePointer
    ,?main:Bool = false, ?scale:Int = 0
  ){
    this.width  = width;
    this.height = height;
    this.tex    = tex;
    this.main   = main;
    this.scale  = scale;
    
    wh    = width * height;
    whpix = wh << 2;
    
    if (untyped __cpp__("{0} == NULL", tex)){
      this.tex = SDL.createTexture(
           Platform.ren, SDL.PIXELFORMAT_ARGB8888, SDL.TEXTUREACCESS_TARGET
          ,width, height
        );
    }
  }
  
  public var debug:Bool = false;
  
  public inline function get(x:Int, y:Int):Colour {
    if (!FM.withinI(x, 0, width - 1) || !FM.withinI(y, 0, height - 1)){
      return 0;
    }
    //y = height - y - 1;
    var ret = new Vector<Colour>(1);
    untyped __cpp__("SDL_Rect rect");
    if (main && scale != 0){
      untyped __cpp__(
           "rect.x = {0} << {2}; rect.y = {1} << {2}; rect.w = 1 << {2}; rect.h = 1 << {2}"
          ,x, y, scale
        );
    } else {
      untyped __cpp__(
           "rect.x = {0}; rect.y = {1}; rect.w = 1; rect.h = 1"
          ,x, y
        );
    }
    SDL.setRenderTarget(Platform.ren, main ? untyped __cpp__("NULL") : tex);
    SDL.renderReadPixels(
         Platform.ren, untyped __cpp__("&rect"), 0 //(cast SDL.PIXELFORMAT_ARGB8888:Int)
        ,cpp.Pointer.ofArray(ret.toData()).ptr, 4
      );
    if (debug){
      trace("got here", x, y, main, ret);
    }
    return ret[0];
  }
  
  public inline function set(x:Int, y:Int, colour:Colour):Void {
    fillRect(x, y, 1, 1, colour);
  }
  
  public function getVector():Vector<Colour> {
    var ret = new Vector<Colour>(wh);
    var tmp = SDL.createTexture(
         Platform.ren, SDL.PIXELFORMAT_ARGB8888, SDL.TEXTUREACCESS_TARGET
        ,width, height
      );
    SDL.setRenderTarget(Platform.ren, tmp);
    SDL.setTextureBlendMode(tex, SDL.BLENDMODE_NONE);
    SDL.renderCopy(Platform.ren, tex, untyped __cpp__("NULL"), untyped __cpp__("NULL"));
    SDL.renderReadPixels(
         Platform.ren, untyped __cpp__("NULL"), 0
//        ,cpp.Pointer.ofArray(ret.toData()).ptr, width * 4
        ,cpp.Pointer.arrayElem(ret.toData(), ret.length - width).ptr, -width * 4
      );
    SDL.destroyTexture(tmp);
    return ret;
  }
  
  public function setVector(vector:Vector<Colour>):Void {
    SDL.updateTexture(
         tex, untyped __cpp__("NULL")
        ,cpp.Pointer.ofArray(vector.toData()).ptr, width * 4
      );
  }
  
  public function getVectorRect(
    x:Int, y:Int, width:Int, height:Int
  ):Vector<Colour> {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    untyped __cpp__("SDL_Rect rect");
    if (main && scale != 0){
      untyped __cpp__(
           "rect.x = {0} << {4}; rect.y = {1} << {4}; rect.w = {2} << {4}; rect.h = {3} << {4}"
          ,x, y, width, height, scale
        );
    } else {
      untyped __cpp__(
           "rect.x = {0}; rect.y = {1}; rect.w = {2}; rect.h = {3}"
          ,x, y, width, height
        );
    }
    
    var ret = new Vector<Colour>(width * height);
    var tmp = SDL.createTexture(
         Platform.ren, SDL.PIXELFORMAT_ARGB8888, SDL.TEXTUREACCESS_TARGET
        ,width, height
      );
    SDL.setRenderTarget(Platform.ren, tmp);
    SDL.setTextureBlendMode(tex, SDL.BLENDMODE_NONE);
    SDL.renderCopy(Platform.ren, tex, untyped __cpp__("&rect"), untyped __cpp__("NULL"));
    SDL.renderReadPixels(
         Platform.ren, untyped __cpp__("NULL"), 0
//        ,cpp.Pointer.ofArray(ret.toData()).ptr, width * 4
        ,cpp.Pointer.arrayElem(ret.toData(), ret.length - width).ptr, -width * 4
      );
    SDL.destroyTexture(tmp);
    return ret;
  }
  
  public function setVectorRect(
    x:Int, y:Int, width:Int, height:Int, vector:Vector<Colour>
  ):Void {
    x = FM.clampI(x, 0, this.width);
    y = FM.clampI(y, 0, this.height);
    width = FM.clampI(width, 1, this.width - x);
    height = FM.clampI(height, 1, this.height - y);
    untyped __cpp__("SDL_Rect rect");
    if (main && scale != 0){
      untyped __cpp__(
           "rect.x = {0} << {4}; rect.y = {1} << {4}; rect.w = {2} << {4}; rect.h = {3} << {4}"
          ,x, y, width, height, scale
        );
    } else {
      untyped __cpp__(
           "rect.x = {0}; rect.y = {1}; rect.w = {2}; rect.h = {3}"
          ,x, y, width, height
        );
    }
    SDL.updateTexture(
         tex, untyped __cpp__("&rect")
        ,cpp.Pointer.ofArray(vector.toData()).ptr, width * 4
      );
    SDL.unlockTexture(tex);
  }
  
  public function fill(colour:Colour):Void {
    SDL.setRenderTarget(Platform.ren, main ? untyped __cpp__("NULL") : tex);
    SDL.setRenderDrawColor(Platform.ren, colour.ri, colour.gi, colour.bi, colour.ai);
    SDL.renderFillRect(Platform.ren, untyped __cpp__("NULL"));
  }
  
  public function fillRect(
    x:Int, y:Int, width:Int, height:Int, colour:Colour
  ):Void {
    untyped __cpp__("SDL_Rect rect");
    if (main && scale != 0){
      untyped __cpp__(
           "rect.x = {0} << {4}; rect.y = {1} << {4}; rect.w = {2} << {4}; rect.h = {3} << {4}"
          ,x, y, width, height, scale
        );
    } else {
      untyped __cpp__(
           "rect.x = {0}; rect.y = {1}; rect.w = {2}; rect.h = {3}"
          ,x, y, width, height
        );
    }
    SDL.setRenderTarget(Platform.ren, main ? untyped __cpp__("NULL") : tex);
    SDL.setRenderDrawColor(Platform.ren, colour.ri, colour.gi, colour.bi, colour.ai);
    SDL.renderFillRect(Platform.ren, untyped __cpp__("&rect"));
    SDL.unlockTexture(tex);
  }
  
  public inline function blitAlpha(src:Bitmap, x:Int, y:Int):Void {
    blitAlphaRect(src, x, y, 0, 0, src.width, src.height);
  }
  
  public function blitAlphaRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void {
    untyped __cpp__("SDL_Rect srcrect; SDL_Rect dstrect");
    if (main && scale != 0){
      untyped __cpp__(
           "srcrect.x = {0}; srcrect.y = {1}; srcrect.w = {2}; srcrect.h = {3}"
          ,srcX, srcY, srcW, srcH
        );
      untyped __cpp__(
           "dstrect.x = {1} << {0}; dstrect.y = {2} << {0}; dstrect.w = {3} << {0}; dstrect.h = {4} << {0}"
          ,scale, dstX, dstY, srcW, srcH
        );
    } else {
      untyped __cpp__(
           "srcrect.x = {0}; srcrect.y = {1}; srcrect.w = dstrect.w = {2}; srcrect.h = dstrect.h = {3}; dstrect.x = {4}; dstrect.y = {5}"
          ,srcX, srcY, srcW, srcH, dstX, dstY
        );
    }
    SDL.setRenderTarget(Platform.ren, main ? untyped __cpp__("NULL") : tex);
    SDL.setTextureBlendMode(src.tex, SDL.BLENDMODE_BLEND);
    // no alpha: SDL.BLENDMODE_NONE
    SDL.renderCopy(Platform.ren, src.tex, untyped __cpp__("&srcrect"), untyped __cpp__("&dstrect"));
  }
}

#end
