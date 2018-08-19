package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.plat.Platform;

/**
##Bitmap manipulator - Turn##
 */
class Turn extends Manipulator {
  public var angle(default, null):Int;
  
  public function new(angle:Int) {
    this.angle = angle;
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var ovec = bitmap.getVector();
    var nw = bitmap.width;
    var nh = bitmap.height;
    if (angle % 2 == 1) {
      nw = bitmap.height;
      nh = bitmap.width;
    }
    var tx = 0;
    var ty = 0;
    var xx = 0;
    var xy = 0;
    var yx = 0;
    var yy = 0;
    switch (angle) {
      case 0: xx = yy = 1;
      case 1: tx = bitmap.height - 1; xy = -1; yx = 1;
      case 3: ty = bitmap.width - 1; xy = 1; yx = -1;
      case _:
    }
    var vi = 0;
    var vec = new Vector<Colour>(nw * nh);
    for (y in 0...bitmap.height) for (x in 0...bitmap.width) {
      vec[tx + xx * x + xy * y + (ty + yx * x + yy * y) * nw] = ovec[vi];
      vi++;
    }
    var ret = Platform.createBitmap(nw, nh, 0);
    ret.setVector(vec);
    return ret;
  }
}
