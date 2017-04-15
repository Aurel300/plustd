package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.bmp.Colour;
import sk.thenet.plat.Platform;
import sk.thenet.plat.Bitmap;
import sk.thenet.plat.Bitmap;

class Recolour extends VectorManipulator {
  public var colour(default, null):Colour;
  
  public function new(colour:Colour){
    super();
    this.colour = colour;
  }
  
  override private inline function manipulatePixel(
    vector:Vector<UInt>, i:Int, original:UInt
  ):UInt {
    return (original & 0xFF000000) | (colour & 0xFFFFFF);
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
