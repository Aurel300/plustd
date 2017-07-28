package sk.thenet.bmp.manip;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.plat.Platform;

class Rotate extends Manipulator {
  public var angle(default, null):Float;
  
  public function new(angle:Float) {
    this.angle = angle;
  }
  
  override public function extract(bitmap:Bitmap):Bitmap {
    var ret = Platform.createBitmap(bitmap.width * 2, bitmap.height * 2, 0);
    var cos = Math.cos(angle);
    var sin = Math.sin(angle);
    var ovec = bitmap.getVector();
    var vec = ret.getVector();
    var vi = 0;
    var hw = (bitmap.width / 2);
    var hh = (bitmap.height / 2);
    for (y in 0...ret.height) for (x in 0...ret.width) {
      var px:Int = x - bitmap.width;
      var py:Int = y - bitmap.height;
      var ox:Int = FM.floor( px * cos + py * sin + hw);
      var oy:Int = FM.floor(-px * sin + py * cos + hh);
      if (ox >= 0 && oy >= 0 && ox < bitmap.width && oy < bitmap.height) {
        vec[vi] = ovec[ox + oy * bitmap.width];
      }
      vi++;
    }
    ret.setVector(vec);
    return ret;
  }
}
