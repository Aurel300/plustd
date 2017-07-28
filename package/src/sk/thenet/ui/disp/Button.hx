package sk.thenet.ui.disp;

import sk.thenet.bmp.Bitmap;
import sk.thenet.ui.Display;

class Button extends Display {
  public var bmp:Bitmap;
  public var bmpOver:Bitmap;
  public var bmpDown:Bitmap;
  
  public function new(
     bmp:Bitmap, bmpOver:Bitmap, bmpDown:Bitmap
    ,x:Int, y:Int, z:Int, w:Int, h:Int, ?name:String
  ) {
    super(x, y, z, w, h, name);
    this.bmp     = bmp;
    this.bmpOver = bmpOver;
    this.bmpDown = bmpDown;
  }
  
  override public function render(target:Bitmap, ox:Int, oy:Int):Void {
    var ubmp = bmp;
    if (mouseDown) {
      ubmp = bmpDown;
    } else if (mouseOver) {
      ubmp = bmpOver;
    }
    if (ubmp == null) {
      return;
    }
    target.blitAlphaRect(ubmp, ox, oy, 0, 0, w, h);
  }
}
