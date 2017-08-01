package sk.thenet.ui.disp;

import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.manip.Box;
import sk.thenet.geom.Point2DI;
import sk.thenet.plat.Platform;
import sk.thenet.ui.Display;

class BoxPanel extends Display {
  public var bmpSource:Bitmap;
  public var bmpCache:Bitmap;
  public var lw:Int;
  public var lh:Int;
  public var cut1:Point2DI;
  public var cut2:Point2DI;
  
  public function new(
     bmp:Bitmap, cut1:Point2DI, cut2:Point2DI
    ,x:Int, y:Int, z:Int, w:Int, h:Int, ?name:String
  ) {
    super(x, y, z, w, h, name);
    bmpSource = bmp;
    this.cut1 = cut1;
    this.cut2 = cut2;
    update();
  }
  
  override public function update():Void {
    super.update();
    if (w == lw && h == lh) {
      return;
    }
    lw = w;
    lh = h;
    bmpCache = bmpSource.fluent >> new Box(cut1, cut2, w, h);
  }
  
  override public function render(target:Bitmap, ox:Int, oy:Int):Void {
    update();
    if (bmpCache == null) {
      return;
    }
    target.blitAlpha(bmpCache, ox, oy);
  }
}
