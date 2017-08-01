package sk.thenet.ui.disp;

import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.ui.Display;

class SolidPanel extends Display {
  public var colour:Colour;
  
  public function new(
    colour:Colour, x:Int, y:Int, z:Int, w:Int, h:Int, ?name:String
  ) {
    super(x, y, z, w, h, name);
    this.colour = colour;
  }
  
  override public function render(target:Bitmap, ox:Int, oy:Int):Void {
    target.fillRect(ox, oy, w, h, colour);
  }
}
