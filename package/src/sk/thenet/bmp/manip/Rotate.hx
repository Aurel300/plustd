package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.plat.Platform;

/**
##Bitmap manipulator - Rotate##

Rotation using nearest neighbour algorithm. Creates a square bitmap with side
twice as big as the largest side of the original bitmap.
 */
class Rotate extends Manipulator {
  public var angle(default, null):Float;
  
  public function new(angle:Float) {
    this.angle = angle;
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var hm = FM.maxI(bitmap.width, bitmap.height);
    var max = hm << 1;
    var cos = Math.cos(angle);
    var sin = Math.sin(angle);
    var ovec = bitmap.getVector();
    var vec = new Vector<Colour>(max * max);
    var hw = bitmap.width / 2;
    var hh = bitmap.height / 2;
    var vi = 0;
    for (y in 0...max) for (x in 0...max) {
      var px:Int = x - hm;
      var py:Int = y - hm;
      var ox:Int = FM.floor( px * cos + py * sin + hw);
      var oy:Int = FM.floor(-px * sin + py * cos + hh);
      if (ox >= 0 && oy >= 0 && ox < bitmap.width && oy < bitmap.height) {
        vec[vi] = ovec[ox + oy * bitmap.width];
      }
      vi++;
    }
    var ret = Platform.createBitmap(max, max, 0);
    ret.setVector(vec);
    return ret;
  }
}
