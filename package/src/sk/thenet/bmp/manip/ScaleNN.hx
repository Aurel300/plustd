package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Bitmap;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

/**
##Bitmap manipulator - Scale nearest neighbour##

Scaling using nearest neighbour algorithm.
 */
class ScaleNN extends Manipulator {
  public var xScale(default, null):Float;
  public var yScale(default, null):Float;
  
  public function new(xScale:Float, yScale:Float) {
    if (xScale <= 0 || yScale <= 0) {
      throw "invalid scale";
    }
    this.xScale = xScale;
    this.yScale = yScale;
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var resx = (bitmap.width * xScale).floor();
    var resy = (bitmap.height * yScale).floor();
    var vec = new Vector<Colour>(resx * resy);
    var ovec = bitmap.getVector();
    var i = 0;
    for (y in 0...resy) {
      for (x in 0...resx) {
        vec[i] = ovec[(y / yScale).floor() * bitmap.width + (x / xScale).floor()];
        i++;
      }
    }
    var ret = Platform.createBitmap(resx, resy, 0);
    ret.setVector(vec);
    return ret;
  }
}
