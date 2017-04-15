package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.plat.Platform;
import sk.thenet.plat.Bitmap;

class Bitmask extends VectorManipulator {
  public var mask:UInt;
  
  public function new(mask:UInt){
    super();
    this.mask = mask;
  }
  
  override private inline function manipulatePixel(
    vector:Vector<UInt>, i:Int, original:UInt
  ):UInt {
    return (original & mask);
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
