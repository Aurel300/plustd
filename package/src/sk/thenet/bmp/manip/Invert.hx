package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.plat.Platform;
import sk.thenet.bmp.Bitmap;

/**
##Bitmap manipulator - Invert##

Inverts the RGB channels.
 */
class Invert extends VectorManipulator {
  override private inline function manipulatePixel(
    vector:Vector<UInt>, i:Int, original:UInt
  ):UInt {
    return (original & 0xFF000000) | (0xFFFFFF - (original & 0xFFFFFF));
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var ret = Platform.createBitmap(bitmap.width, bitmap.height, 0);
    ret.setVector(vectorApply(
        bitmap, function(vector, i, val) return manipulatePixel(vector, i, val)
      ));
    return ret;
  }
  
  override public function manipulate(bitmap:Bitmap):Void {
    bitmap.setVector(vectorApply(
        bitmap, function(vector, i, val) return manipulatePixel(vector, i, val)
      ));
  }
}
