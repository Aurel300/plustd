package sk.thenet.ui;

import sk.thenet.event.*;

class EDisplayClick extends Event {
  public var display:Display;
  
  public function new(source:Source, display:Display) {
    super(source, "displayclick");
    this.display = display;
  }
}
