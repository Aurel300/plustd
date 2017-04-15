package sk.thenet.plat.neko;

#if neko

import sk.thenet.app.Keyboard;
import sk.thenet.app.Mouse;
import sk.thenet.bmp.Colour;
import sk.thenet.net.ws.Websocket;
import sk.thenet.plat.Bitmap;
import sk.thenet.plat.Output;
import sk.thenet.plat.Surface;
import sk.thenet.event.Source;

/**
##Platform - Neko##

The neko platform, used when the `neko` compiler switch is enabled.

@see `sk.thenet.plat.Platform`
 */
class Platform extends sk.thenet.plat.PlatformBase {
  public static var isSocketCapable      (default, never):Bool = true;
  public static var isSocketServerCapable(default, never):Bool = true;
  public static var isWebsocketCapable   (default, never):Bool = true;
  
  // private constructor to prevent instantiation
  private function new(){}
    
  public static inline function createAudioOutput():Output {
    throw "unsupported operation";
  }
  
  public static inline function createBitmap(
    width:Int, height:Int, colour:Colour
  ):Bitmap {
    throw "unsupported operation";
  }
  
  public static inline function createSocket():Socket {
    return new Socket();
  }
  
  public static inline function createWebsocket():Websocket {
    return new Websocket();
  }
}

#end
