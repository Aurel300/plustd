package sk.thenet.app;

import haxe.ds.Vector;

/**
##Keyboard##

Base class for keyboard handler implementations. Generally accessible through
`sk.thenet.plat.Platform.keyboard` or `sk.thenet.app.Application.keyboard`,
if using the application class.

@see `sk.thenet.event.EKEvent`
 */
class Keyboard {
  private static var KEY_CHARACTERS:String = " 0123456789abcdefghijklmnopqrstuvwxyz \n";
  
  public inline static function isCharacter(key:Key):Bool {
    return ((cast key:Int) >= 4 && (cast key:Int) <= 40)
      || ((cast key:Int) == 42);
  }
  
  public inline static function getCharacter(key:Key):String {
    if (isCharacter(key)){
      return KEY_CHARACTERS.charAt((cast key:Int) - 4);
    }
    return "";
  }
  
  private var keysHeld:Vector<Bool>;
  
  private function new(){
    keysHeld = new Vector<Bool>(Key.Invalid);
    for (i in 0...keysHeld.length){
      keysHeld[i] = false;
    }
  }
  
  /**
@return `true` iff the given `key` is currently being held.
   */
  public inline function isHeld(key:Key):Bool {
    return keysHeld[key];
  }
}

/**
##Key##

Enumeration of keys known to plustd.
 */
@:enum
abstract Key(Int) from Int to Int {
  var ArrowLeft     = 0  ;
  var ArrowUp       = 1  ;
  var ArrowRight    = 2  ;
  var ArrowDown     = 3  ;
  var Space         = 4  ;
  var Digit0        = 5  ;
  var Digit1        = 6  ;
  var Digit2        = 7  ;
  var Digit3        = 8  ;
  var Digit4        = 9  ;
  var Digit5        = 10 ;
  var Digit6        = 11 ;
  var Digit7        = 12 ;
  var Digit8        = 13 ;
  var Digit9        = 14 ;
  var KeyA          = 15 ;
  var KeyB          = 16 ;
  var KeyC          = 17 ;
  var KeyD          = 18 ;
  var KeyE          = 19 ;
  var KeyF          = 20 ;
  var KeyG          = 21 ;
  var KeyH          = 22 ;
  var KeyI          = 23 ;
  var KeyJ          = 24 ;
  var KeyK          = 25 ;
  var KeyL          = 26 ;
  var KeyM          = 27 ;
  var KeyN          = 28 ;
  var KeyO          = 29 ;
  var KeyP          = 30 ;
  var KeyQ          = 31 ;
  var KeyR          = 32 ;
  var KeyS          = 33 ;
  var KeyT          = 34 ;
  var KeyU          = 35 ;
  var KeyV          = 36 ;
  var KeyW          = 37 ;
  var KeyX          = 38 ;
  var KeyY          = 39 ;
  var KeyZ          = 40 ;
  var Backspace     = 41 ;
  var Enter         = 42 ;
  
  var Invalid       = 43 ;
}