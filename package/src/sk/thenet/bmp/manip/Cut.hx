package sk.thenet.bmp.manip;

import sk.thenet.plat.Platform;
import sk.thenet.bmp.Bitmap;

/**
##Bitmap manipulator - Cut##

Cuts out a rectangular patch of the given bitmap when extracting.
 */
class Cut extends Manipulator {
  public var x     (default, null):Int;
  public var y     (default, null):Int;
  public var width (default, null):Int;
  public var height(default, null):Int;
  
  public function new(x:Int, y:Int, width:Int, height:Int) {
    this.x      = x;
    this.y      = y;
    this.width  = width;
    this.height = height;
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var ret = Platform.createBitmap(width, height, 0);
    ret.setVector(bitmap.getVectorRect(x, y, width, height));
    return ret;
  }
}