package sk.thenet.plat.js.common.app;

import js.html.MouseEvent;
import sk.thenet.FM;
import sk.thenet.app.Mouse as AppMouse;
import sk.thenet.event.*;

/**
JavaScript implementation of `sk.thenet.app.Mouse`.

@see `sk.thenet.app.Mouse`
 */
@:allow(sk.thenet.plat.js)
class Mouse extends AppMouse {
  private function new(){
    super();
  }
  
  private function handleClick(
    source:Source, e:MouseEvent, scale:Int
  ):EMEvent {
    x = FM.floor(e.offsetX) >> scale;
    y = FM.floor(e.offsetY) >> scale;
    return new EMEvent.EMClick(source, x, y);
  }
  
  private function handleMove(
    source:Source, e:MouseEvent, scale:Int
  ):EMEvent {
    x = FM.floor(e.offsetX) >> scale;
    y = FM.floor(e.offsetY) >> scale;
    return new EMEvent.EMMove(source, x, y);
  }
  
  private function handleButton(
    source:Source, e:MouseEvent, held:Bool, scale:Int
  ):EMEvent {
    x = FM.floor(e.offsetX) >> scale;
    y = FM.floor(e.offsetY) >> scale;
    if (this.held == held){
      return null;
    }
    this.held = held;
    if (held){
      return new EMEvent.EMDown(source, x, y);
    }
    return new EMEvent.EMUp(source, x, y);
  }
}
