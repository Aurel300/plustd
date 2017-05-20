package sk.thenet.plat.js.canvas;

#if js

import js.Browser;
import js.html.CanvasElement;
import js.html.Event as NativeEvent;
import js.html.EventTarget;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import sk.thenet.U;
import sk.thenet.app.Application;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Surface;
import sk.thenet.event.ETick;
import sk.thenet.event.*;
import sk.thenet.plat.Capabilities;
import sk.thenet.plat.js.common.app.Keyboard;
import sk.thenet.plat.js.common.app.Mouse;
import sk.thenet.plat.js.common.audio.Output;
import sk.thenet.plat.js.common.net.ws.Websocket;
import sk.thenet.plat.js.canvas.bmp.Bitmap;

/**
##Platform - JavaScript / Canvas##

The JavaScript / Canvas platform.

@see `sk.thenet.plat.Platform`
 */
class Platform extends sk.thenet.plat.PlatformBase {
  public static var capabilities(default, never):Capabilities
    = new Capabilities([
         Keyboard
        ,Mouse
        ,Realtime
        ,Surface
        ,Websocket
      ]);
  
  public static var keyboard(default, null):Keyboard;
  public static var mouse   (default, null):Mouse;
  
  private static var scale:Int = 0;
  private static var canvas:CanvasElement;
  
  // prevent instantiation
  private function new(){}
  
  public static inline function initFramerate(fps:Float):Void {
    //Browser.window.setInterval(handleFrame, 1000 / fps);
    Browser.window.requestAnimationFrame(handleFrame);
  }
  
  private static function handleFrame(v):Void {
    source.fireEvent(new ETick(source));
    Browser.window.requestAnimationFrame(handleFrame);
  }
  
  private static inline function addEventListener<T:NativeEvent>(
    target:EventTarget, event:String, handler:T->Void
  ):Void {
    target.addEventListener(event, handler);
  }
  
  public static inline function initKeyboard():Keyboard {
    keyboard = new Keyboard();
    addEventListener(Browser.document.body, "keydown", handleKeyDown);
    addEventListener(Browser.document.body, "keyup",   handleKeyUp  );
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
    addEventListener(canvas, "click",     handleMouseClick);
    addEventListener(canvas, "mousedown", handleMouseDown );
    addEventListener(canvas, "mouseup",   handleMouseUp   );
    addEventListener(canvas, "mousemove", handleMouseMove );
    return mouse;
  }
  
  private static inline function handleMouseClick(e:MouseEvent):Void {
    source.fireEvent(mouse.handleClick(source, e, scale));
  }
  
  private static inline function handleMouseDown(e:MouseEvent):Void {
    U.callNotNull(
        source.fireEvent, mouse.handleButton(source, e, true, scale)
      );
  }
  
  private static inline function handleMouseMove(e:MouseEvent):Void {
    source.fireEvent(mouse.handleMove(source, e, scale));
  }
  
  private static inline function handleMouseUp(e:MouseEvent):Void {
    U.callNotNull(
        source.fireEvent, mouse.handleButton(source, e, false, scale)
      );
  }
  
  public static inline function initSurface(
    width:Int, height:Int, ?scale:Int = 0
  ):Surface {
    canvas = (cast Browser.document.querySelector("#surf"):CanvasElement);
    canvas.width = width;
    canvas.height = height;
    var scaledWidth = width << scale;
    var scaledHeight = height << scale;
    canvas.style.cssText = [
         'width:${scaledWidth}px;'
        ,'height:${scaledHeight}px;'
        ,"image-rendering:optimizeSpeed;"
        ,"image-rendering:-moz-crisp-edges;"
        ,"image-rendering:-webkit-optimize-contrast;"
        ,"image-rendering:-o-crisp-edges;"
        ,"image-rendering:pixelated;"
        ,"-ms-interpolation-mode:nearest-neighbor;"
        ,"-webkit-touch-callout:none;"
        ,"-webkit-user-select:none;"
        ,"-khtml-user-select:none;"
        ,"-moz-user-select:none;"
        ,"-ms-user-select:none;"
        ,"user-select:none;"
      ].join("");
    Platform.scale = scale;
    return new Surface(new Bitmap(canvas));
  }
  
  public static inline function createAudioOutput(
    ?channels:Int = 2, ?samples:Int = 8192
  ):Output {
    return new Output(channels, samples);
  }
  
  public static inline function createBitmap(
    width:Int, height:Int, colour:Colour
  ):Bitmap {
    var canvas = (cast Browser.document.createElement("canvas"):CanvasElement);
    canvas.width = width;
    canvas.height = height;
    var bmp = new Bitmap(canvas);
    bmp.fill(colour);
    return bmp;
  }
  
  public static inline function createWebsocket():Websocket {
    return new Websocket();
  }
  
  public static inline function boot(func:Void->Void):Void {
    Browser.window.onload = func;
  }
}

#end
