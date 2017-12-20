package sk.thenet.bmp.manip;

import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Bitmap;

/**
##Bitmap manipulator - Glow box##

A simple glow consisting of recolouring any transparent pixels immediately
next to a non-transparent pixel.
 */
class GlowBox extends Manipulator {
  public var colour(default, null):Colour;
  
  public function new(colour:Colour) {
    this.colour = colour;
  }
  
  override public function manipulate(bitmap:Bitmap):Void {
    var vec = bitmap.getVector();
    var ovec = vec.copy();
    var i:Int = 0;
    for (y in 0...bitmap.height) for (x in 0...bitmap.width) {
      if ((vec[i] & 0xFF000000) != 0) {
        //vec[i] = 0xFF00FFFF;
        // pass
      } else if ((x > 0 && (ovec[i - 1] & 0xFF000000) != 0)
          || (y > 0 && (ovec[i - bitmap.width] & 0xFF000000) != 0)
          || (x < bitmap.width - 1 && (ovec[i + 1] & 0xFF000000) != 0)
          || (y < bitmap.height - 1 && (ovec[i + bitmap.width] & 0xFF000000) != 0)
          || (x > 0 && y > 0 && (ovec[i - 1 - bitmap.width] & 0xFF000000) != 0)
          || (x < bitmap.width - 1 && y > 0 && (ovec[i + 1 - bitmap.width] & 0xFF000000) != 0)
          || (x < bitmap.width - 1 && y < bitmap.height - 1 && (ovec[i + 1 + bitmap.width] & 0xFF000000) != 0)
          || (x > 0 && y < bitmap.height - 1 && (ovec[i - 1 + bitmap.width] & 0xFF000000) != 0)) {
        vec[i] = colour;
      }
      i++;
    }
    bitmap.setVector(vec);
  }
}
