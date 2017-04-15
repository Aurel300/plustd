package sk.thenet.plat.dummy;

import sk.thenet.app.Keyboard;
import sk.thenet.app.Mouse;
import sk.thenet.bmp.Colour;
import sk.thenet.net.ws.Websocket;
import sk.thenet.plat.Bitmap;
import sk.thenet.plat.Output;
import sk.thenet.plat.Socket;
import sk.thenet.plat.Surface;
import sk.thenet.event.Source;

/**
##Platform - Dummy##

This is a dummy platform. It is provided as a fallback in case no other platform
is detected. It also serves as the API documentation for public static methods
which should be implemented by any platform.

@see `sk.thenet.plat.dummy.Platform`
 */
class Platform extends PlatformBase {
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
  private function new(){}
  
  /**
Keyboard capable platforms support keyboard events.
   */
  public static var isKeyboardCapable(default, never):Bool = false;
  
  /**
Mouse capable platforms support mouse events.
   */
  public static var isMouseCapable(default, never):Bool = false;
  
  /**
Real-time capable platforms support a constant framerate and can fire regular
tick events.
   */
  public static var isRealtimeCapable(default, never):Bool = false;
  
  /**
Socket capable platforms can create a socket object which can be used to connect
via TCP to a remote server on a given port.
   */
  public static var isSocketCapable(default, never):Bool = false;
  
  /**
Socket server capable platforms can create a socket object and use it to listen
for incoming TCP connections.
   */
  public static var isSocketServerCapable(default, never):Bool = false;
  
  /**
Surface capable platforms can create a bitmap surface which the application can
use to display information, components, etc. to the user.
   */
  public static var isSurfaceCapable(default, never):Bool = false;
  
  /**
Websocket capable platforms can connect via the websocket protocol to a remote
server. This is separate from `isSocketCapable`, because JavaScript in the
browser can connect to Websocket servers, but not arbitrary socket servers.
   */
  public static var isWebocketCapable(default, never):Bool = false;
  
  /**
Window capable platforms can create a main window with a title and display it
in the window system of the underlying OS.
   */
  public static var isWindowCapable(default, never):Bool = false;
  
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
Creates and returns a `sk.thenet.plat.Output`.

@return A platform-dependent representation of a code-generated audio output.
   */
  public static inline function createAudioOutput():Output {
    throw "unsupported operation";
  }
  
  /**
Creates and returns a `sk.thenet.plat.Bitmap` of the given dimensions filled
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
Creates and returns a `sk.thenet.plat.Socket`.

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
