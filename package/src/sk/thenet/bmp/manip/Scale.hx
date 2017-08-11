package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Bitmap;
import sk.thenet.plat.Platform;

/**
##Bitmap manipulator - Scale##

Scaling using nearest neighbour algorithm. Only accepts integer multiples.
 */
class Scale extends Manipulator {
  public var xScale(default, null):Int;
  public var yScale(default, null):Int;
  
  public function new(xScale:Int, yScale:Int) {
    if (xScale <= 0 || yScale <= 0) {
      throw "invalid scale";
    }
    this.xScale = xScale;
    this.yScale = yScale;
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var vec = new Vector<Colour>(bitmap.width * bitmap.height * xScale * yScale);
    var ovec = bitmap.getVector();
    var oi = 0;
    var i = 0;
    for (y in 0...bitmap.height) {
      for (sy in 0...yScale) {
        for (x in 0...bitmap.width) {
          for (sx in 0...xScale) {
            vec[i] = ovec[y * bitmap.width + x];
            i++;
          }
          if (sy == yScale - 1) {
            oi++;
          }
        }
      }
    }
    var ret = Platform.createBitmap(bitmap.width * xScale, bitmap.height * yScale, 0);
    ret.setVector(vec);
    return ret;
  }
}
