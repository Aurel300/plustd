package sk.thenet.plat.dummy;

import sk.thenet.app.Keyboard;
import sk.thenet.app.Mouse;
import sk.thenet.audio.Output;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Surface;
import sk.thenet.event.Source;
import sk.thenet.net.Socket;
import sk.thenet.net.ws.Websocket;

/**
##Platform - Dummy##

This is a dummy platform. It is provided as a fallback in case no other platform
is detected. It also serves as the API documentation for public static methods
and properties which should be implemented by any platform.

@see `sk.thenet.plat.dummy.Platform`
 */
class Platform extends PlatformBase {
  /**
The object summarising the capabilities of this platform.
   */
  public static var capabilities(default, never):Capabilities
    = new Capabilities();
  
  /**
The event source which is used to fire platform-dependent events. Events are
only triggered after the appropriate `init*` method has been called.

If using `sk.thenet.app.Application`, use the appropriate
`sk.thenet.app.ApplicationInit` instead of calling the `init*` methods directly.
   */
  public static var source(default, never):Source = new Source();
  
  /**
Keyboard instance, if capable and initialised.

If using `sk.thenet.app.Application`, use
`sk.thenet.app.ApplicationInit.Keyboard` instead of calling
`Platform.initKeyboard` directly.
   */
  public static var keyboard(default, never):Keyboard = null;
  
  /**
Mouse instance, if capable and initialised.

If using `sk.thenet.app.Application`, use
`sk.thenet.app.ApplicationInit.Mouse` instead of calling
`Platform.initMouse` directly.
   */
  public static var mouse(default, never):Mouse = null;
  
  // private constructor to prevent instantiation
  private function new() {}
  
  /**
Initialises the main frame ticker and starts triggering the frame event.

On some platforms this function will never return.

@param fps Frames per second.
   */
  public static inline function initFramerate(fps:Float):Void {
    throw "unsupported operation";
  }
  
  /**
Initialises and starts triggering keyboard events.
   */
  public static inline function initKeyboard():Keyboard {
    throw "unsupported operation";
  }
  
  /**
Initialises and starts triggering mouse events.
   */
  public static inline function initMouse():Mouse {
    throw "unsupported operation";
  }
  
  /**
Initialises the main drawing surface.

@param width Width of the surface in pixels.
@param height Height of the surface in pixels.
@param scale Scale the surface to `2 ^ scale` on each side. Default: 0

@return Main surface.
   */
  public static inline function initSurface(
    width:Int, height:Int, ?scale:Int = 0
  ):Surface {
    throw "unsupported operation";
  }
  
  /**
Initialises the main window with the given parameters.
   */
  public static inline function initWindow(
    title:String, width:Int, height:Int
  ):Void {
    throw "unsupported operation";
  }
  
  /**
Creates and returns a `sk.thenet.audio.Output`.

@return A platform-dependent representation of a code-generated audio output.
   */
  public static inline function createAudioOutput():Output {
    throw "unsupported operation";
  }
  
  /**
Creates and returns a `sk.thenet.bmp.Bitmap` of the given dimensions filled
with the specified colour.

@param width Width, in pixels.
@param height Height, in pixels.
@param colour The initial colour of the bitmap, in a 32-bit ARGB format.

@return A platform-dependent representation of a bitmap.
   */
  public static inline function createBitmap(
    width:Int, height:Int, colour:Colour
  ):Bitmap {
    throw "unsupported operation";
  }
  
  /**
Creates and returns a `sk.thenet.net.Socket`.

@return A platform-dependent representation of a socket object.
   */
  public static inline function createSocket():Socket {
    throw "unsupported operation";
  }
  
  /**
Creates and returns a `sk.thenet.net.ws.Websocket`.

@return A platform-dependent representation of a Websocket object.
   */
  public static inline function createWebsocket():Websocket {
    throw "unsupported operation";
  }
}
