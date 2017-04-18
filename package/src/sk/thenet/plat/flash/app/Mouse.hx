package sk.thenet.plat.flash.app;

import flash.events.MouseEvent;
import sk.thenet.FM;
import sk.thenet.app.Mouse as AppMouse;
import sk.thenet.event.*;

/**
Flash implementation of `sk.thenet.app.Mouse`.

@see `sk.thenet.app.Mouse`
 */
@:allow(sk.thenet.plat.flash.Platform)
class Mouse extends AppMouse {
  private function new(){
    super();
  }
  
  private function handleClick(
    source:Source, e:MouseEvent, scale:Int
  ):EMEvent {
    x = FM.floor(e.stageX) >> scale;
    y = FM.floor(e.stageY) >> scale;
    return new EMEvent.EMClick(source, x, y);
  }
  
  private function handleMove(
    source:Source, e:MouseEvent, scale:Int
  ):EMEvent {
    x = FM.floor(e.stageX) >> scale;
    y = FM.floor(e.stageY) >> scale;
    return new EMEvent.EMMove(source, x, y);
  }
  
  private function handleButton(
    source:Source, e:MouseEvent, held:Bool, scale:Int
  ):EMEvent {
    x = FM.floor(e.stageX) >> scale;
    y = FM.floor(e.stageY) >> scale;
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
