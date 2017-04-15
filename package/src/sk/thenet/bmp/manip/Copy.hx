package sk.thenet.bmp.manip;

import sk.thenet.plat.Bitmap;

class Copy extends Manipulator {
  public var x     (default, null):Int;
  public var y     (default, null):Int;
  public var bitmap(default, null):Bitmap;
  
  public function new(x:Int, y:Int, bitmap:Bitmap){
    super();
    this.x      = x;
    this.y      = y;
    this.bitmap = bitmap;
  }
  
  override public function manipulate(bitmap:Bitmap):Void {
    bitmap.setVectorRect(
        x, y, this.bitmap.width, this.bitmap.height, this.bitmap.getVector()
      );
  }
}