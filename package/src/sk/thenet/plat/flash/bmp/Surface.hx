package sk.thenet.plat.flash.bmp;

#if flash

import flash.display.Bitmap as NativeBitmap;
import sk.thenet.bmp.Bitmap;

/**
Flash implementation of `sk.thenet.bmp.ISurface`.

@see `sk.thenet.bmp.ISurface`
 */
@:allow(sk.thenet.plat.flash.Platform)
class Surface implements sk.thenet.bmp.ISurface {
  public var bitmap(default, null):Bitmap;
  private var native:NativeBitmap;
  
  private function new(native:NativeBitmap, bitmap:Bitmap){
    this.native = native;
    this.bitmap = bitmap;
  }
}

#end
