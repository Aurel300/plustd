package sk.thenet.ui;

import sk.thenet.event.*;

class EDisplayDrag extends Event {
  public var display:Display;
  public var rx:Int;
  public var ry:Int;
  public var offX:Int;
  public var offY:Int;
  
  public function new(source:Source, display:Display, rx:Int, ry:Int, offX:Int, offY:Int) {
    super(source, "displaydrag");
    this.display = display;
    this.rx = rx;
    this.ry = ry;
    this.offX = offX;
    this.offY = offY;
  }
}
