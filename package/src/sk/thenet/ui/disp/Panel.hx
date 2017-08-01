package sk.thenet.ui.disp;

import sk.thenet.bmp.Bitmap;
import sk.thenet.ui.Display;
import sk.thenet.plat.Platform;

class Panel extends Display {
  public var bmp:Bitmap;
  
  public function new(
     bmp:Bitmap, x:Int, y:Int, z:Int, w:Int, h:Int
    ,?name:String, ?clip:Bool = false
  ) {
    super(x, y, z, w, h, name);
    this.clip = clip;
    if (clip) {
      clipTarget = Platform.createBitmap(w, h, 0);
    }
    this.bmp = bmp;
  }
  
  override public function render(target:Bitmap, ox:Int, oy:Int):Void {
    if (bmp == null) {
      return;
    }
    target.blitAlphaRect(bmp, ox, oy, 0, 0, w, h);
  }
}
