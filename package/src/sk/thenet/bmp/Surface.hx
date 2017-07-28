package sk.thenet.bmp;

/**
##Surface##

This interface represents main surfaces that can be drawn onto.

Currently it does not serve much purpose, as it is only a wrapper for `Bitmap`.
 */
class Surface {
  public var bitmap(default, null):Bitmap;
  
  public function new(bitmap:Bitmap) {
    this.bitmap = bitmap;
  }
}
