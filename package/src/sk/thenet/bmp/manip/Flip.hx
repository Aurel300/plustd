package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.plat.Platform;

class Flip extends Manipulator {
  public var vertical:Bool;
  
  public function new(?vertical:Bool = false) {
    this.vertical = vertical;
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var ret = Platform.createBitmap(bitmap.width, bitmap.height, 0);
    var ovec = bitmap.getVector();
    var vec = ret.getVector();
    var vi = 0;
    for (y in 0...ret.height) for (x in 0...ret.width) {
      var ox = x;
      var oy = y;
      if (vertical) {
        oy = bitmap.height - oy - 1;
      } else {
        ox = bitmap.width - ox - 1;
      }
      vec[vi] = ovec[ox + oy * bitmap.width];
      vi++;
    }
    ret.setVector(vec);
    return ret;
  }
}
