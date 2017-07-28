package sk.thenet.ui;

import sk.thenet.bmp.Bitmap;

class Display {
  public var x:Int;
  public var y:Int;
  public var z:Int;
  public var w:Int;
  public var h:Int;
  public var name:String;
  public var parent:Display;
  public var children:Array<Display>;
  public var mouseOver:Bool = false;
  public var mouseDown:Bool = false;
  
  public function new(x:Int, y:Int, z:Int, w:Int, h:Int, ?name:String) {
    this.x    = x;
    this.y    = y;
    this.z    = z;
    this.w    = w;
    this.h    = h;
    this.name = name;
    children  = [];
  }
  
  public function render(target:Bitmap, ox:Int, oy:Int):Void {}
  
  public function update():Void {}
}
