package sk.thenet.event;

import sk.thenet.app.Keyboard.Key;

/**
##Events - Keyboard event##

Base class for all keyboard-related events.

@see `sk.thenet.event.EKDown`
@see `sk.thenet.event.EKUp`
 */
class EKEvent extends Event {
  /**
The key for this event.

@see `sk.thenet.input.Keyboard`
   */
  public var key(default, null):Key;
  
  public function new(source:Source, key:Key, type:String){
    super(source, type);
    this.key = key;
  }
}

/**
##Events - Key down##

Event name: `kdown`

This event is fired when the user presses down a key on the keyboard,
once `sk.thenet.plat.Platform.initKeyboard()` has been called.
 */
class EKDown extends EKEvent {
  public function new(source:Source, key:Key){
    super(source, key, "kdown");
  }
}

/**
##Events - Key up##

Event name: `kup`

This event is fired when the user releases a key on the keyboard,
once `sk.thenet.plat.Platform.initKeyboard()` has been called.
 */
class EKUp extends EKEvent {
  public function new(source:Source, key:Key){
    super(source, key, "kup");
  }
}
