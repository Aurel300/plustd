package sk.thenet.bmp.manip;

import sk.thenet.plat.Platform;
import sk.thenet.bmp.Bitmap;

/**
##Bitmap manipulator - Copy##
 */
class Copy extends Manipulator {
  public function new() {}
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var ret = Platform.createBitmap(bitmap.width, bitmap.height, 0);
    ret.setVector(bitmap.getVector());
    return ret;
  }
}