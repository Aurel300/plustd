package sk.thenet.ui;

import sk.thenet.bmp.Bitmap;
import sk.thenet.event.Source;

class Display extends Source {
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
  public var clip:Bool = false;
  public var clipTarget:Bitmap;
  public var sort:Bool = true;
  public var show:Bool = true;
  
  public var fullName(get, never):String;
  private inline function get_fullName():String {
    var ret = [];
    var c = this;
    while (c != null) {
      if (c.name != null) {
        ret.unshift(c.name);
      }
      c = c.parent;
    }
    return ret.join(".");
  }
  
  public var fullX(get, never):Int;
  private inline function get_fullX():Int {
    var ret = 0;
    var c = this;
    while (c != null) {
      ret += c.x;
      c = c.parent;
    }
    return ret;
  }
  
  public var fullY(get, never):Int;
  private inline function get_fullY():Int {
    var ret = 0;
    var c = this;
    while (c != null) {
      ret += c.y;
      c = c.parent;
    }
    return ret;
  }
  
  public function new(x:Int, y:Int, z:Int, w:Int, h:Int, ?name:String) {
    super();
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
