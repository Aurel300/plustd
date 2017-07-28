package sk.thenet.plat.cppsdl.common.app;

#if cpp

import sk.thenet.FM;
import sk.thenet.app.Mouse as AppMouse;
import sk.thenet.event.*;

/**
C++ / SDL implementation of `sk.thenet.app.Mouse`.

@see `sk.thenet.app.Mouse`
 */
@:allow(sk.thenet.plat.cppsdl)
class Mouse extends AppMouse {
  private function new() {
    super();
  }
  
  private function handleClick(
    source:Source, x:Int, y:Int, scale:Int
  ):EMEvent {
    this.x = x >> scale;
    this.y = y >> scale;
    return new EMEvent.EMClick(source, this.x, this.y);
  }
  
  private function handleMove(
    source:Source, x:Int, y:Int, scale:Int
  ):EMEvent {
    this.x = x >> scale;
    this.y = y >> scale;
    return new EMEvent.EMMove(source, this.x, this.y);
  }
  
  private function handleButton(
    source:Source, x:Int, y:Int, held:Bool, scale:Int
  ):EMEvent {
    this.x = x >> scale;
    this.y = y >> scale;
    if (this.held == held) {
      return null;
    }
    this.held = held;
    if (held) {
      return new EMEvent.EMDown(source, this.x, this.y);
    }
    return new EMEvent.EMUp(source, this.x, this.y);
  }
}

#end
