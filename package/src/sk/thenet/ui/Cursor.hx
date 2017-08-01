package sk.thenet.ui;

import sk.thenet.bmp.Bitmap;

class Cursor {
  public var bitmap:Bitmap;
  public var offX:Int;
  public var offY:Int;
  
  public function new(bitmap:Bitmap, offX:Int, offY:Int) {
    this.bitmap = bitmap;
    this.offX   = offX;
    this.offY   = offY;
  }
}
