package sk.thenet.bmp.manip;

import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Bitmap;

/**
##Bitmap manipulator - Alpha mask##

Overrides the alpha of the manipulated bitmap with the alpha of its parameter
`bitmap`.
 */
class AlphaMask extends Manipulator {
  public var bitmap(default, null):Bitmap;
  public var ignoreEmpty(default, null):Bool;
  
  public function new(bitmap:Bitmap, ?ignoreEmpty:Bool = false) {
    this.bitmap = bitmap;
    this.ignoreEmpty = ignoreEmpty;
  }
  
  override public function manipulate(bitmap:Bitmap):Void {
    var vec = bitmap.getVector();
    var avec = this.bitmap.getVector();
    var i:Int = 0;
    for (y in 0...bitmap.height) for (x in 0...bitmap.width) {
      if (ignoreEmpty && (vec[i] & 0xFF000000) == 0) {
        i++;
        continue;
      }
      vec[i] = (avec[i] & 0xFF000000) | (vec[i] & 0xFFFFFF);
      i++;
    }
    bitmap.setVector(vec);
  }
}
