package sk.thenet.bmp.manip;

import sk.thenet.plat.Platform;
import sk.thenet.bmp.Bitmap;

/**
##Bitmap manipulator - Grow##
 */
class Grow extends Manipulator {
  public var x1:Int;
  public var x2:Int;
  public var y1:Int;
  public var y2:Int;
  
  public function new(x1:Int, x2:Int, y1:Int, y2:Int) {
    this.x1 = x1;
    this.x2 = x2;
    this.y1 = y1;
    this.y2 = y2;
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var ret = Platform.createBitmap(bitmap.width + x1 + x2, bitmap.height + y1 + y2, 0);
    ret.blitAlpha(bitmap, x1, y1);
    return ret;
  }
}