package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.bmp.Colour;
import sk.thenet.plat.Platform;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Bitmap;

/**
##Bitmap manipulator - Replace colour##
 */
class ReplaceColour extends VectorManipulator {
  public var find:Colour;
  public var replace:Colour;
  
  public function new(find:Colour, replace:Colour) {
    this.find    = find;
    this.replace = replace;
  }
  
  override private inline function manipulatePixel(
    vector:Vector<UInt>, i:Int, original:UInt
  ):UInt {
    return (original == find ? replace : original);
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
