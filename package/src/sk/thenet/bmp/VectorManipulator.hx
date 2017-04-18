package sk.thenet.bmp;

import haxe.ds.Vector;
import sk.thenet.plat.Platform;
import sk.thenet.bmp.Bitmap;

class VectorManipulator extends Manipulator {
  private function new(){
    super();
  }
  
  private function manipulatePixel(
    vector:Vector<UInt>, i:Int, original:UInt
  ):UInt {
    return original;
  }
  
  private inline function vectorApply(
    bitmap:Bitmap, func:Vector<UInt>->Int->UInt->UInt
  ):Vector<UInt> {
    var vector:Vector<UInt> = bitmap.getVector();
    for (i in 0...vector.length){
      vector[i] = func(vector, i, vector[i]);
    }
    return vector;
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