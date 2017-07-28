package sk.thenet.ui;

import sk.thenet.event.*;

class EDisplayClick extends Event {
  public var display:Display;
  public var x:Int;
  public var y:Int;
  public var uiX:Int;
  public var uiY:Int;
  
  public function new(source:Source, display:Display, x:Int, y:Int) {
    super(source, "displayclick");
    this.display = display;
    var dx = display.x;
    var dy = display.y;
    var c = display.parent;
    while (c != null) {
      dx += c.x;
      dy += c.y;
      c = c.parent;
    }
    this.x = x - dx;
    this.y = y - dy;
    this.uiX = x;
    this.uiY = y;
  }
}
