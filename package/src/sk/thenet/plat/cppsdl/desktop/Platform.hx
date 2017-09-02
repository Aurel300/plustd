package sk.thenet.plat.cppsdl.desktop;

#if cpp

import sk.thenet.M;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Surface;
import sk.thenet.event.ETick;
import sk.thenet.event.*;
import sk.thenet.net.ws.Websocket;
import sk.thenet.plat.Capabilities;
import sk.thenet.plat.cppsdl.common.SDL;
import sk.thenet.plat.cppsdl.common.SDL.RendererPointer;
import sk.thenet.plat.cppsdl.common.SDL.TexturePointer;
import sk.thenet.plat.cppsdl.common.SDL.WindowPointer;
import sk.thenet.plat.cppsdl.common.app.Keyboard;
import sk.thenet.plat.cppsdl.common.app.Mouse;
import sk.thenet.plat.cppsdl.common.audio.Output;
import sk.thenet.plat.cppsdl.common.bmp.Bitmap;

/**
##Platform - C++ / SDL / Desktop##

The C++ / SDL / Desktop platform.

 - `PLUSTD_TARGET` identifier: `cppsdl.desktop`.
 - `PLUSTD_OS` can be: `osx`, `windows`, `linux`.

@see `sk.thenet.plat.Platform`
 */
@:allow(sk.thenet.plat.cppsdl)
@:build(sk.thenet.plat.cppsdl.common.SDLMacro.master("../common/"))
class Platform extends sk.thenet.plat.PlatformBase {
  public static var capabilities(default, never):Capabilities
    = new Capabilities([
         Embed
        ,Keyboard
        ,Mouse
        ,Realtime
        ,Surface
        ,Window
      ]);
  
  // prevent instantiation
  private function new() {}
  
  public static var keyboard(default, null):Keyboard;
  
  public static var mouse(default, null):Mouse;
  
  private static var window:WindowPointer;
  private static var ren:RendererPointer;
  private static var scale:Int = 0;
  private static var surface:Surface;
  private static var bitmap:Bitmap;
  private static var running:Bool = false;
  
  public static inline function initFramerate(fps:Float):Void {
    SDL.initSubSystem(SDL.INIT_EVENTS);
    running = true;
    untyped __cpp__("SDL_Event event");
    while (running) {
      source.fireEvent(new ETick(source));
      while (untyped __cpp__("SDL_PollEvent(&event)") != 0) {
        var etype = untyped __cpp__("event.type");
        switch (etype) {
          case (SDL.KEYDOWN | SDL.KEYUP) if (keyboard != null):
          var code:Int = untyped __cpp__("event.key.keysym.sym");
          M.callDenull(source.fireEvent, keyboard.handleKey(
              source, code, etype == SDL.KEYDOWN
            ));
          
          case SDL.TEXTINPUT if (keyboard != null):
          var text:String = cpp.NativeString.fromPointer(untyped __cpp__("event.text.text"));
          M.callDenull(source.fireEvent, keyboard.handleText(
              source, text
            ));
          
          case SDL.MOUSEMOTION if (mouse != null):
          var x:Int = untyped __cpp__("event.button.x");
          var y:Int = untyped __cpp__("event.button.y");
          source.fireEvent(mouse.handleMove(source, x, y, scale));
          
          case (SDL.MOUSEBUTTONDOWN | SDL.MOUSEBUTTONUP) if (mouse != null):
          var x:Int = untyped __cpp__("event.button.x");
          var y:Int = untyped __cpp__("event.button.y");
          M.callDenull(source.fireEvent, mouse.handleButton(
              source, x, y, etype == SDL.MOUSEBUTTONDOWN, scale
            ));
          if (etype == SDL.MOUSEBUTTONDOWN) {
            source.fireEvent(mouse.handleClick(source, x, y, scale));
          }
          
          case SDL.QUIT:
          source.fireEvent(new EQuit(source));
          running = false;
          
          case _:
        }
      }
      if (surface != null) {
        surface.bitmap.blitAlpha(bitmap, 0, 0);
        SDL.setRenderTarget(ren, untyped __cpp__("NULL"));
        SDL.renderPresent(ren);
      }
      if (!running) {
        SDL.quit();
      } else {
        SDL.delay(FM.floor(1000 / fps));
      }
    }
  }
  
  public static inline function quit():Void {
    running = false;
  }
  
  public static inline function initWindow(
    title:String, width:Int, height:Int
  ):Void {
    SDL.initSubSystem(SDL.INIT_VIDEO);
    window = SDL.createWindow(
         title, SDL.WINDOWPOS_CENTERED, SDL.WINDOWPOS_CENTERED
        ,width, height, SDL.WINDOW_OPENGL
      );
  }
  
  public static inline function initKeyboard():Keyboard {
    keyboard = new Keyboard();
    SDL.startTextInput();
    return keyboard;
  }
  
  public static inline function initMouse():Mouse {
    mouse = new Mouse();
    return mouse;
  }
  
  public static inline function initSurface(
    width:Int, height:Int, ?scale:Int = 0
  ):Surface {
    Platform.scale = scale;
    ren = SDL.createRenderer(
        window, -1, SDL.RENDERER_ACCELERATED | SDL.RENDERER_TARGETTEXTURE
      );
    var bitmap = new Bitmap(width, height);
    var bitmapScaled = new Bitmap(
        width, height, null, true, scale
      );
    bitmap.fill(0xFF000000);
    bitmapScaled.fill(0xFF000000);
    Platform.bitmap = bitmap;
    surface = new Surface(bitmapScaled);
    return new Surface(bitmap);
  }
  
  public static inline function createAudioOutput():Output {
    return new Output();
  }
  
  public static inline function createBitmap(
    width:Int, height:Int, colour:Colour
  ):Bitmap {
    var ret = new Bitmap(width, height);
    ret.fill(colour);
    return ret;
  }
  
  public static function boot(func:Void->Void):Void {
    SDL.init(0);
    func();
  }
}

#end
