package sk.thenet.plat.neko;

#if neko

import sk.thenet.app.Keyboard;
import sk.thenet.app.Mouse;
import sk.thenet.audio.Output;
import sk.thenet.bmp.Colour;
import sk.thenet.event.Source;
import sk.thenet.plat.Capabilities;
import sk.thenet.plat.common.bmp.Bitmap;
import sk.thenet.plat.common.net.ws.Websocket;

/**
##Platform - Neko##

The neko platform, used when the `neko` compiler switch is enabled.

@see `sk.thenet.plat.Platform`
 */
class Platform extends sk.thenet.plat.PlatformBase {
  public static var capabilities(default, never):Capabilities
    = new Capabilities([
         Socket
        ,SocketServer
        ,Websocket
      ]);
  
  // private constructor to prevent instantiation
  private function new(){}
    
  public static inline function createAudioOutput():Output {
    throw "unsupported operation";
  }
  
  public static inline function createBitmap(
    width:Int, height:Int, colour:Colour
  ):Bitmap {
    return new Bitmap(width, height, colour);
  }
  
  public static inline function createSocket():Socket {
    return new Socket();
  }
  
  public static inline function createWebsocket():Websocket {
    return new Websocket();
  }
}

#end
