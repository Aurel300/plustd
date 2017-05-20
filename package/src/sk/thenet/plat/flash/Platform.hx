package sk.thenet.plat.flash;

#if flash

import flash.display.Bitmap as NativeBitmap;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.media.Sound as NativeSound;
import sk.thenet.U;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Surface;
import sk.thenet.event.ETick;
import sk.thenet.event.*;
import sk.thenet.net.ws.Websocket;
import sk.thenet.plat.Capabilities;
import sk.thenet.plat.flash.app.Keyboard;
import sk.thenet.plat.flash.app.Mouse;
import sk.thenet.plat.flash.audio.Output;
import sk.thenet.plat.flash.audio.Sound;
import sk.thenet.plat.flash.bmp.Bitmap;
import sk.thenet.plat.flash.net.Socket;

/**
##Platform - Flash##

The Adobe Flash / swf platform, used when the `flash` compiler switch is
enabled.

@see `sk.thenet.plat.Platform`
 */
class Platform extends sk.thenet.plat.PlatformBase {
  public static var capabilities(default, never):Capabilities
    = new Capabilities([
         Keyboard
        ,Mouse
        ,Realtime
        ,Socket
        ,Surface
        ,Websocket
      ]);
  
  public static var keyboard(default, null):Keyboard;
  public static var mouse   (default, null):Mouse;
  
  private static var stage:Stage = flash.Lib.current.stage;
  private static var scale:Int = 0;
  
  // prevent instantiation
  private function new(){}
  
  /**
On Flash, the argument to this function is ignored in favour of the framerate
provided in the `-swf-header` haxe compiler option.
   */
  public static inline function initFramerate(fps:Float):Void {
    stage.addEventListener(Event.ENTER_FRAME, handleFrame);
  }
  
  private static function handleFrame(ev:Dynamic):Void {
    source.fireEvent(new ETick(source));
  }
  
  public static inline function initKeyboard():Keyboard {
    keyboard = new Keyboard();
    stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
    stage.addEventListener(KeyboardEvent.KEY_UP,   handleKeyUp  );
    return keyboard;
  }
  
  private static inline function handleKeyDown(e:KeyboardEvent):Void {
    U.callNotNull(source.fireEvent, keyboard.handleKey(source, e, true));
  }
  
  private static inline function handleKeyUp(e:KeyboardEvent):Void {
    U.callNotNull(source.fireEvent, keyboard.handleKey(source, e, false));
  }
  
  public static inline function initMouse():Mouse {
    mouse = new Mouse();
    stage.addEventListener(MouseEvent.CLICK,      handleMouseClick);
    stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown );
    stage.addEventListener(MouseEvent.MOUSE_UP,   handleMouseUp   );
    stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove );
    return mouse;
  }
  
  private static inline function handleMouseClick(e:Dynamic):Void {
    source.fireEvent(mouse.handleClick(source, e, scale));
  }
  
  private static inline function handleMouseDown(e:Dynamic):Void {
    U.callNotNull(
        source.fireEvent, mouse.handleButton(source, e, true, scale)
      );
  }
  
  private static inline function handleMouseMove(e:Dynamic):Void {
    source.fireEvent(mouse.handleMove(source, e, scale));
  }
  
  private static inline function handleMouseUp(e:Dynamic):Void {
    U.callNotNull(
        source.fireEvent, mouse.handleButton(source, e, false, scale)
      );
  }
  
  /**
On Flash, the `width` and `height` arguments passed to this function are ignored
in favour of the ones  provided in the `-swf-header` haxe compiler option.
   */
  public static inline function initSurface(
    width:Int, height:Int, ?scale:Int = 0
  ):Surface {
    var bd:BitmapData = new BitmapData(width, height, true, 0);
    var native = new NativeBitmap(bd);
    native.scaleX = native.scaleY = (1 << scale);
    stage.addChild(native);
    Platform.scale = scale;
    return new Surface(new Bitmap(bd));
  }
  
  public static inline function createAudioOutput():Output {
    return new Output();
  }
  
  public static inline function createBitmap(
    width:Int, height:Int, colour:Colour
  ):Bitmap {
    return new Bitmap(new BitmapData(width, height, true, colour));
  }
  
  public static inline function createSoundNative(sound:NativeSound):Sound {
    return new Sound(sound);
  }
  
  public static inline function createBitmapNative(bd:BitmapData):Bitmap {
    return new Bitmap(bd);
  }
  
  public static inline function createSocket():Socket {
    return new Socket();
  }
  
  public static inline function createWebsocket():Websocket {
    return new Websocket();
  }
  
  public static inline function boot(func:Void->Void):Void {
    func();
  }
}

#end
