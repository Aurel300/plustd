package sk.thenet.plat.flash.app;

#if flash

import haxe.ds.Vector;
import flash.events.KeyboardEvent;
import sk.thenet.app.Keyboard as AppKeyboard;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.event.*;

/**
Flash implementation of `sk.thenet.app.Keyboard`.

@see `sk.thenet.app.Keyboard`
 */
@:allow(sk.thenet.plat.flash)
class Keyboard extends AppKeyboard {
  private var lookup:Vector<Key>;
  private var lookupLen:UInt;
  
  private function new() {
    super();
    lookup = new Vector<Key>(91);
    lookupLen = lookup.length;
    for (i in 0...lookup.length) {
      lookup[i] = Key.Invalid;
    }
    lookup[37] = Key.ArrowLeft;
    lookup[38] = Key.ArrowUp;
    lookup[39] = Key.ArrowRight;
    lookup[40] = Key.ArrowDown;
    lookup[32] = Key.Space;
    lookup[48] = Key.Digit0;
    lookup[49] = Key.Digit1;
    lookup[50] = Key.Digit2;
    lookup[51] = Key.Digit3;
    lookup[52] = Key.Digit4;
    lookup[53] = Key.Digit5;
    lookup[54] = Key.Digit6;
    lookup[55] = Key.Digit7;
    lookup[56] = Key.Digit8;
    lookup[57] = Key.Digit9;
    lookup[65] = Key.KeyA;
    lookup[66] = Key.KeyB;
    lookup[67] = Key.KeyC;
    lookup[68] = Key.KeyD;
    lookup[69] = Key.KeyE;
    lookup[70] = Key.KeyF;
    lookup[71] = Key.KeyG;
    lookup[72] = Key.KeyH;
    lookup[73] = Key.KeyI;
    lookup[74] = Key.KeyJ;
    lookup[75] = Key.KeyK;
    lookup[76] = Key.KeyL;
    lookup[77] = Key.KeyM;
    lookup[78] = Key.KeyN;
    lookup[79] = Key.KeyO;
    lookup[80] = Key.KeyP;
    lookup[81] = Key.KeyQ;
    lookup[82] = Key.KeyR;
    lookup[83] = Key.KeyS;
    lookup[84] = Key.KeyT;
    lookup[85] = Key.KeyU;
    lookup[86] = Key.KeyV;
    lookup[87] = Key.KeyW;
    lookup[88] = Key.KeyX;
    lookup[89] = Key.KeyY;
    lookup[90] = Key.KeyZ;
    lookup[8 ] = Key.Backspace;
    lookup[13] = Key.Enter;
    // TODO: try a switch?
  }
  
  private function handleKey(
    source:Source, e:KeyboardEvent, down:Bool
  ):EKEvent {
    var key = Key.Invalid;
    if (e.keyCode < lookupLen) {
      key = lookup[e.keyCode];
    }
    if (key == Key.Invalid || keysHeld[key] == down) {
      return null;
    }
    keysHeld[key] = down;
    if (down) {
      return new EKEvent.EKDown(source, key);
    }
    return new EKEvent.EKUp(source, key);
  }
  
  private function handleText(
    source:Source, e:KeyboardEvent
  ):EText {
    if (e.charCode == 0) {
      return null;
    }
    return new EText(source, String.fromCharCode(e.charCode));
  }
}

#end
