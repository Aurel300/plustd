package sk.thenet.bmp.manip;

import sk.thenet.plat.Platform;
import sk.thenet.bmp.Bitmap;

/**
##Bitmap manipulator - Blit##
 */
class Blit extends Manipulator {
  public var bitmap(default, null):Bitmap;
  public var x     (default, null):Int;
  public var y     (default, null):Int;
  
  public function new(bitmap:Bitmap, ?x:Int = 0, ?y:Int = 0) {
    this.bitmap = bitmap;
    this.x      = x;
    this.y      = y;
  }
  
  override public function manipulate(bitmap:Bitmap):Void {
    bitmap.blitAlpha(this.bitmap, x, y);
  }
}