package sk.thenet.ui;

import sk.thenet.event.*;

class EDisplayDrop extends Event {
  public var dropped:Display;
  public var display:Display;
  
  public function new(source:Source, dropped:Display, display:Display) {
    super(source, "displaydrop");
    this.dropped = dropped;
    this.display = display;
  }
}
