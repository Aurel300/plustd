package sk.thenet.plat.js.common.app;

#if js

import js.html.KeyboardEvent;
import sk.thenet.app.Keyboard as AppKeyboard;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.event.*;

/**
JavaScript implementation of `sk.thenet.app.Keyboard`.

@see `sk.thenet.app.Keyboard`
 */
@:allow(sk.thenet.plat.js)
class Keyboard extends AppKeyboard {
  private var lookup:Map<String, Key>;
  
  private function new() {
    super();
    lookup = new Map();
    lookup.set("ArrowLeft",  Key.ArrowLeft );
    lookup.set("ArrowUp",    Key.ArrowUp   );
    lookup.set("ArrowRight", Key.ArrowRight);
    lookup.set("ArrowDown",  Key.ArrowDown );
    lookup.set("Space",      Key.Space     );
    lookup.set("Digit0",     Key.Digit0    );
    lookup.set("Digit1",     Key.Digit1    );
    lookup.set("Digit2",     Key.Digit2    );
    lookup.set("Digit3",     Key.Digit3    );
    lookup.set("Digit4",     Key.Digit4    );
    lookup.set("Digit5",     Key.Digit5    );
    lookup.set("Digit6",     Key.Digit6    );
    lookup.set("Digit7",     Key.Digit7    );
    lookup.set("Digit8",     Key.Digit8    );
    lookup.set("Digit9",     Key.Digit9    );
    lookup.set("KeyA",       Key.KeyA      );
    lookup.set("KeyB",       Key.KeyB      );
    lookup.set("KeyC",       Key.KeyC      );
    lookup.set("KeyD",       Key.KeyD      );
    lookup.set("KeyE",       Key.KeyE      );
    lookup.set("KeyF",       Key.KeyF      );
    lookup.set("KeyG",       Key.KeyG      );
    lookup.set("KeyH",       Key.KeyH      );
    lookup.set("KeyI",       Key.KeyI      );
    lookup.set("KeyJ",       Key.KeyJ      );
    lookup.set("KeyK",       Key.KeyK      );
    lookup.set("KeyL",       Key.KeyL      );
    lookup.set("KeyM",       Key.KeyM      );
    lookup.set("KeyN",       Key.KeyN      );
    lookup.set("KeyO",       Key.KeyO      );
    lookup.set("KeyP",       Key.KeyP      );
    lookup.set("KeyQ",       Key.KeyQ      );
    lookup.set("KeyR",       Key.KeyR      );
    lookup.set("KeyS",       Key.KeyS      );
    lookup.set("KeyT",       Key.KeyT      );
    lookup.set("KeyU",       Key.KeyU      );
    lookup.set("KeyV",       Key.KeyV      );
    lookup.set("KeyW",       Key.KeyW      );
    lookup.set("KeyX",       Key.KeyX      );
    lookup.set("KeyY",       Key.KeyY      );
    lookup.set("KeyZ",       Key.KeyZ      );
    lookup.set("Backspace",  Key.Backspace );
    lookup.set("Enter",      Key.Enter     );
  }
  
  private function handleKey(
    source:Source, e:KeyboardEvent, down:Bool
  ):EKEvent {
    var code:String = untyped __js__("{0}.code", e);
    if (!lookup.exists(code)) {
      return null;
    }
    var key:Key = lookup.get(code);
    if (keysHeld[key] == down) {
      return null;
    }
    keysHeld[key] = down;
    if (down) {
      return new EKEvent.EKDown(source, key);
    }
    return new EKEvent.EKUp(source, key);
  }
}

#end
