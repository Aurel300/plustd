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
  
  /**
The string representation of this key, or null.
   */
  public var char(default, null):String;
  
  public function new(source:Source, key:Key, char:String, type:String) {
    super(source, type);
    this.key  = key;
    this.char = char;
  }
}

/**
##Events - Key down##

Event name: `kdown`

This event is fired when the user presses down a key on the keyboard,
once `sk.thenet.plat.Platform.initKeyboard()` has been called.
 */
class EKDown extends EKEvent {
  public function new(source:Source, key:Key, char:String) {
    super(source, key, char, "kdown");
  }
}

/**
##Events - Key up##

Event name: `kup`

This event is fired when the user releases a key on the keyboard,
once `sk.thenet.plat.Platform.initKeyboard()` has been called.
 */
class EKUp extends EKEvent {
  public function new(source:Source, key:Key, char:String) {
    super(source, key, char, "kup");
  }
}
