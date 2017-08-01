package sk.thenet.bmp.manip;

import sk.thenet.bmp.Bitmap;
import sk.thenet.geom.Point2DI;
import sk.thenet.plat.Platform;

/**
##Bitmap manipulator - Box##

Expands a box with specified borders to the given dimensions.
 */
class Box extends Manipulator {
  public var cut1  (default, null):Point2DI;
  public var cut2  (default, null):Point2DI;
  public var width (default, null):Int;
  public var height(default, null):Int;
  
  var midw:Int;
  var midh:Int;
  
  public function new(cut1:Point2DI, cut2:Point2DI, width:Int, height:Int) {
    this.cut1   = cut1;
    this.cut2   = cut2;
    this.width  = width;
    this.height = height;
    midw = cut2.x - cut1.x;
    midh = cut2.y - cut1.y;
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    if (height == 0 || width == 0) {
      return null;
    }
    var cutw = bitmap.width - cut2.x;
    var cuth = bitmap.height - cut2.y;
    var ret = Platform.createBitmap(width, height, 0);
    ret.blitAlphaRect(bitmap, 0, 0, 0, 0, cut1.x, cut1.y);
    ret.blitAlphaRect(bitmap, width - cutw, 0, cut2.x, 0, cutw, cut1.y);
    ret.blitAlphaRect(bitmap, 0, height - cuth, 0, cut2.y, cut1.x, cuth);
    ret.blitAlphaRect(bitmap, width - cutw, height - cuth, cut2.x, cut2.y, cutw, cuth);
    if (midw > 0) {
      var x = cut1.x;
      var xl = width - (bitmap.width - midw);
      while (xl > 0) {
        ret.blitAlphaRect(bitmap, x, 0, cut1.x, 0, FM.minI(midw, xl), cut1.y);
        ret.blitAlphaRect(bitmap, x, height - cuth, cut1.x, cut2.y, FM.minI(midw, xl), cut1.y);
        x += midw;
        xl -= midw;
      }
    }
    if (midh > 0) {
      var y = cut1.y;
      var yl = height - (bitmap.height - midh);
      while (yl > 0) {
        ret.blitAlphaRect(bitmap, 0, y, 0, cut1.y, cut1.x, FM.minI(midh, yl));
        ret.blitAlphaRect(bitmap, width - cutw, y, cut2.x, cut1.y, cut1.x, FM.minI(midh, yl));
        y += midh;
        yl -= midh;
      }
    }
    if (midw > 0 && midh > 0) {
      var x = cut1.x;
      var xl = width - (bitmap.width - midw);
      while (xl > 0) {
        var y = cut1.y;
        var yl = height - (bitmap.height - midh);
        while (yl > 0) {
          ret.blitAlphaRect(bitmap, x, y, cut1.x, cut1.y, FM.minI(midw, xl), FM.minI(midh, yl));
          y += midh;
          yl -= midh;
        }
        x += midw;
        xl -= midw;
      }
    }
    return ret;
  }
}