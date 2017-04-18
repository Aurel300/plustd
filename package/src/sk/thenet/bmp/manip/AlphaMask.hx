package sk.thenet.bmp.manip;

import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Bitmap;

class AlphaMask extends Manipulator {
  public var bitmap(default, null):Bitmap;
  
  public function new(bitmap:Bitmap){
    super();
    this.bitmap = bitmap;
  }
  
  override public function manipulate(bitmap:Bitmap):Void {
    var vec = bitmap.getVector();
    var avec = this.bitmap.getVector();
    var i:Int = 0;
    for (y in 0...bitmap.height) for (x in 0...bitmap.width){
      vec[i] = (avec[i] & 0xFF000000) | (vec[i] & 0xFFFFFF);
      i++;
    }
    bitmap.setVector(vec);
  }
}
