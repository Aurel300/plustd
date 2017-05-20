package sk.thenet.plat.cppsdl.common.app;

#if cpp

import haxe.ds.Vector;
import sk.thenet.app.Keyboard as AppKeyboard;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.event.*;

/**
C++ / SDL implementation of `sk.thenet.app.Keyboard`.

@see `sk.thenet.app.Keyboard`
 */
@:allow(sk.thenet.plat.cppsdl)
@:build(sk.thenet.plat.cppsdl.common.SDLMacro.slave("../"))
class Keyboard extends AppKeyboard {
  private var lookup:Map<Int, Key>;
  
  private function new(){
    super();
    lookup = new Map<Int, Key>();
    lookup[untyped __cpp__("SDLK_LEFT")] = Key.ArrowLeft;
    lookup[untyped __cpp__("SDLK_UP")] = Key.ArrowUp;
    lookup[untyped __cpp__("SDLK_RIGHT")] = Key.ArrowRight;
    lookup[untyped __cpp__("SDLK_DOWN")] = Key.ArrowDown;
    lookup[untyped __cpp__("SDLK_SPACE")] = Key.Space;
    lookup[untyped __cpp__("SDLK_0")] = Key.Digit0;
    lookup[untyped __cpp__("SDLK_1")] = Key.Digit1;
    lookup[untyped __cpp__("SDLK_2")] = Key.Digit2;
    lookup[untyped __cpp__("SDLK_3")] = Key.Digit3;
    lookup[untyped __cpp__("SDLK_4")] = Key.Digit4;
    lookup[untyped __cpp__("SDLK_5")] = Key.Digit5;
    lookup[untyped __cpp__("SDLK_6")] = Key.Digit6;
    lookup[untyped __cpp__("SDLK_7")] = Key.Digit7;
    lookup[untyped __cpp__("SDLK_8")] = Key.Digit8;
    lookup[untyped __cpp__("SDLK_9")] = Key.Digit9;
    lookup[untyped __cpp__("SDLK_a")] = Key.KeyA;
    lookup[untyped __cpp__("SDLK_b")] = Key.KeyB;
    lookup[untyped __cpp__("SDLK_c")] = Key.KeyC;
    lookup[untyped __cpp__("SDLK_d")] = Key.KeyD;
    lookup[untyped __cpp__("SDLK_e")] = Key.KeyE;
    lookup[untyped __cpp__("SDLK_f")] = Key.KeyF;
    lookup[untyped __cpp__("SDLK_g")] = Key.KeyG;
    lookup[untyped __cpp__("SDLK_h")] = Key.KeyH;
    lookup[untyped __cpp__("SDLK_i")] = Key.KeyI;
    lookup[untyped __cpp__("SDLK_j")] = Key.KeyJ;
    lookup[untyped __cpp__("SDLK_k")] = Key.KeyK;
    lookup[untyped __cpp__("SDLK_l")] = Key.KeyL;
    lookup[untyped __cpp__("SDLK_m")] = Key.KeyM;
    lookup[untyped __cpp__("SDLK_n")] = Key.KeyN;
    lookup[untyped __cpp__("SDLK_o")] = Key.KeyO;
    lookup[untyped __cpp__("SDLK_p")] = Key.KeyP;
    lookup[untyped __cpp__("SDLK_q")] = Key.KeyQ;
    lookup[untyped __cpp__("SDLK_r")] = Key.KeyR;
    lookup[untyped __cpp__("SDLK_s")] = Key.KeyS;
    lookup[untyped __cpp__("SDLK_t")] = Key.KeyT;
    lookup[untyped __cpp__("SDLK_u")] = Key.KeyU;
    lookup[untyped __cpp__("SDLK_v")] = Key.KeyV;
    lookup[untyped __cpp__("SDLK_w")] = Key.KeyW;
    lookup[untyped __cpp__("SDLK_x")] = Key.KeyX;
    lookup[untyped __cpp__("SDLK_y")] = Key.KeyY;
    lookup[untyped __cpp__("SDLK_z")] = Key.KeyZ;
    lookup[untyped __cpp__("SDLK_BACKSPACE")] = Key.Backspace;
    lookup[untyped __cpp__("SDLK_RETURN")] = Key.Enter;
  }
  
  private function handleKey(
    source:Source, code:Int, down:Bool
  ):EKEvent {
    var key:Null<Key> = lookup.get(code);
    if (key == null || keysHeld[key] == down){
      return null;
    }
    keysHeld[key] = down;
    if (down){
      return new EKEvent.EKDown(source, key);
    }
    return new EKEvent.EKUp(source, key);
  }
}

#end
