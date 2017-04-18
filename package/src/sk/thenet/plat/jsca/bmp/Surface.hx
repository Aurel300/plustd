package sk.thenet.plat.jsca.bmp;

import sk.thenet.bmp.Bitmap;

/**
JavaScript / Canvas implementation of `sk.thenet.bmp.ISurface`.

@see `sk.thenet.bmp.ISurface`
 */
@:allow(sk.thenet.plat.jsca)
class Surface implements sk.thenet.bmp.ISurface {
  public var bitmap(default, null):Bitmap;
  
  private function new(bitmap:Bitmap){
    //this.native = native;
    this.bitmap = bitmap;
  }
}
