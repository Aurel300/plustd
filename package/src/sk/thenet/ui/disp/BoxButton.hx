package sk.thenet.ui.disp;

import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.manip.Box;
import sk.thenet.geom.Point2DI;
import sk.thenet.ui.Display;

class BoxButton extends Display {
  public var bmpSource:Bitmap;
  public var bmpSourceOver:Bitmap;
  public var bmpSourceDown:Bitmap;
  public var bmpCache:Bitmap;
  public var bmpCacheOver:Bitmap;
  public var bmpCacheDown:Bitmap;
  public var lw:Int;
  public var lh:Int;
  public var cut1:Point2DI;
  public var cut2:Point2DI;
  
  public function new(
     bmp:Bitmap, bmpOver:Bitmap, bmpDown:Bitmap, cut1:Point2DI, cut2:Point2DI
    ,x:Int, y:Int, z:Int, w:Int, h:Int, ?name:String
  ) {
    super(x, y, z, w, h, name);
    this.bmpSource     = bmp;
    this.bmpSourceOver = bmpOver;
    this.bmpSourceDown = bmpDown;
    this.cut1          = cut1;
    this.cut2          = cut2;
    update();
  }
  
  override public function update():Void {
    super.update();
    if (w == lw || h == lh) {
      return;
    }
    lw = w;
    lh = h;
    var box = new Box(cut1, cut2, w, h);
    bmpCache     = bmpSource.fluent >> box;
    bmpCacheOver = bmpSourceOver.fluent >> box;
    bmpCacheDown = bmpSourceDown.fluent >> box;
  }
  
  override public function render(target:Bitmap, ox:Int, oy:Int):Void {
    update();
    var ubmp = bmpCache;
    if (mouseDown) {
      ubmp = bmpCacheDown;
    } else if (mouseOver) {
      ubmp = bmpCacheOver;
    }
    if (ubmp == null) {
      return;
    }
    target.blitAlpha(ubmp, ox, oy);
  }
}
