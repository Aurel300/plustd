package sk.thenet.bmp.manip;

import sk.thenet.FM;
import sk.thenet.bmp.Colour;
import sk.thenet.plat.Bitmap;

class Shadow extends Manipulator {
  public var colour(default, null):Colour;
  public var offsetX(default, null):Int;
  public var offsetY(default, null):Int;
  
  public function new(colour:Colour, x:Int, y:Int){
    super();
    this.colour = colour;
    this.offsetX = x;
    this.offsetY = y;
  }
  
  override public function manipulate(bitmap:Bitmap):Void {
    var vec = bitmap.getVector();
    var ovec = vec.copy();
    var i:Int = 0;
    for (y in 0...bitmap.height) for (x in 0...bitmap.width){
      if ((ovec[i] & 0xFF000000) != 0){
        // pass
      } else if (FM.withinI(x - offsetX, 0, bitmap.width - 1)
        && FM.withinI(y - offsetY, 0, bitmap.height - 1)
        && ovec[i - offsetX - offsetY * bitmap.width].au != 0){
        vec[i] = colour;
      }
      i++;
    }
    bitmap.setVector(vec);
  }
}
