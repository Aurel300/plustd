package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.plat.Platform;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;

/**
##Bitmap manipulator - Threshold##

Thresholds the alpha channel.
 */
class Threshold extends VectorManipulator {
  public var threshold(default, null):Int;
  
  public function new(threshold:Int){
    this.threshold = threshold;
  }
  
  override private inline function manipulatePixel(
    vector:Vector<UInt>, i:Int, original:Colour
  ):UInt {
    return (original.ai >= threshold ? 0xFF000000 | original : 0);
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
