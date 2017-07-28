package sk.thenet.app;

import sk.thenet.FM;
import sk.thenet.app.Keyboard;
import sk.thenet.app.Keyboard.Key;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.bmp.Font;
import sk.thenet.bmp.Surface;
import sk.thenet.bmp.manip.*;
import sk.thenet.event.EData;
import sk.thenet.event.EKEvent.EKUp;
import sk.thenet.event.Event;
import sk.thenet.event.Source;
import sk.thenet.net.ws.ConsoleLink;
import sk.thenet.plat.Platform;

/**
##Debugging console##

This class provides an interactive console to debug your application. It is
entered by pressing `Enter`.

For now, this class requires a `"console_font"` bitmap asset to work.
 */
@:allow(sk.thenet.app)
class Console extends Source {
  private static inline var HISTORY_SIZE:Int = 20;
  
  public var applicationInits:Array<sk.thenet.app.ApplicationInit>;
  public var applicationTick(default, null):Bool = true;
  
  public var assetManager(default, set):AssetManager;
  
  private function set_assetManager(assetManager:AssetManager):AssetManager {
    if (assetManager == null) {
      return null;
    }
    this.assetManager = assetManager;
    assetManager.add(new AssetBind(
       ["console_font"]
      ,function(assetManager:AssetManager, event:Event):Bool {
        var fluent = assetManager.getBitmap("console_font").fluent;
        fluent = Font.spreadGrid(
             fluent
            ,8, 16
            ,1, 1, 1, 1
          );
        fluent
          << (new Recolour(0xEEEEEE))
          << (new Shadow(0xFF666666, 1, 0))
          << (new Glow(0x99333333));
        font = Font.makeMonospaced(
             fluent
            ,32, 160
            ,10, 18
            ,32
            ,-3, 0
          );
        renderHistory();
        return true;
      }));
    return assetManager;
  }
  
  public var keyboard(default, set):Keyboard;
  
  private function set_keyboard(keyboard:Keyboard):Keyboard {
    if (keyboard == null) {
      return null;
    }
    this.keyboard = keyboard;
    Platform.source.listen("kup", handleKey, true);
    return keyboard;
  }
  
  public var surface(default, set):Surface;
  
  private function set_surface(surface:Surface):Surface {
    if (surface == null) {
      return null;
    }
    this.surface = surface;
    height = (surface.bitmap.height >> 2) * 3; // 3/4
    createBg();
    renderHistory();
    return surface;
  }
  
  private var pause:Bool = false;
  private var frameCount:Int;
  private var frameSlow:Int = 0;
  
  private var font:Font;
  private var bg:Bitmap;
  private var historyCache:Bitmap;
  private var lastFrame:Bitmap;
  private var show:Bool = false;
  private var height:Int;
  private var command:String = "";
  private var history:Array<String> = [];
  private var remote:ConsoleLink;
  
  private function new() {
    history = [ for (i in 0...HISTORY_SIZE) "" ];
    history[HISTORY_SIZE - 2] = "+ plustd console";
    history[HISTORY_SIZE - 1] = "  by Aurel B%l& (thenet.sk)";
    super();
  }
  
  private function attachRemote(host:String, port:Int):Void {
    remote = new ConsoleLink();
    remote.listen("connect", handleConnect);
    remote.listen("data", handleData);
    forward("file", remote);
    remote.connect(host, port);
  }
  
  private function handleConnect(event:Event):Bool {
    history.push("RL connected");
    renderHistory();
    return true;
  }
  
  private function handleData(event:EData):Bool {
    history.push("RL: " + event.data.toString());
    renderHistory();
    return true;
  }
  
  private function monitor(file:String):Void {
    if (remote == null) {
      return;
    }
    remote.monitor(file);
  }
  
  private function createBg():Void {
    bg = Platform.createBitmap(surface.bitmap.width, height, 0);
    historyCache = Platform.createBitmap(surface.bitmap.width, height, 0);
    var vec = bg.getVector();
    var i:Int = 0;
    var base = new Colour(0x33220000);
    for (y in 0...height) for (x in 0...surface.bitmap.width) {
      vec[i] = base.setBf(y / (height * 2)).setGf(x / (surface.bitmap.width * 2));
      i++;
    }
    bg.setVector(vec);
  }
  
  private function renderHistory():Void {
    if (font == null || surface == null) {
      return;
    }
    if (history.length > HISTORY_SIZE) {
      history = history.slice(history.length - HISTORY_SIZE);
    }
    historyCache = Platform.createBitmap(surface.bitmap.width, height, 0);
    var cy:Int = height - 24;
    for (i in 0...history.length) {
      var ri:Int = history.length - i - 1;
      font.render(historyCache, 0, cy, history[ri]);
      cy -= 12;
      if (cy < -12) break;
    }
  }
  
  private function handleKey(e:EKUp):Bool {
    if (!show) {
      if (e.key == Key.Enter) {
        show = true;
        return true;
      }
      return false;
    }
    command = (switch (e.key) {
      case Enter:
      var trimmed = StringTools.trim(command);
      var words = trimmed.split(" ");
      var response:Array<String> = [];
      var showCommand:Bool = true;
      switch (words[0]) {
        case "inits" | "init" | "app":
        if (applicationInits != null) {
          response = [ for (init in applicationInits) switch (init) {
                case Assets(_): "- assets";
                case Console: "- console";
                case Framerate(f): '- framerate($f)';
                case Keyboard: "- keyboard";
                case Mouse: "- mouse";
                case Surface(w, h, s): '- surface($w, $h, $s)';
                case Window(t, w, h): '- window($t, $w, $h)';
                case _: '- ???';
              } ];
        } else {
          response = ["Inits unknown!"];
        }
        
        case "clear" | "cls" | "clr":
        history = [ for (i in 0...HISTORY_SIZE) "" ];
        showCommand = false;
        
        case "" | "hide" | "exit" | "quit" | "q" | "qu":
        show = false;
        showCommand = false;
        
        case "height" | "size" if (words.length == 2):
        height = (switch (words[1]) {
          case "full" | "f": surface.bitmap.height;
          case "half" | "h": surface.bitmap.height >> 1;
          case "default" | "d": (surface.bitmap.height >> 2) * 3;
          case Std.parseInt(_) => h if (h != null):
          FM.clampI(h, 10, surface.bitmap.height);
          case _: response = ["Invalid parameter!"]; height;
        });
        createBg();
        renderHistory();
        
        case "height" | "size":
        response = ["Invalid command format!"];
        
        case "pause" | "stop" | "suspend" | "p":
        pause = true;
        response = ["Paused!"];
        
        case "unpause" | "play" | "resume" | "u" | "up":
        pause = false;
        response = ["Unpaused!"];
        
        case "slow" | "speed" | "frame" | "f" if (words.length == 2):
        frameCount = 0;
        frameSlow = (switch (words[1]) {
          case Std.parseInt(_) => h if (h != null): h;
          case _: response = ["Invalid parameter!"]; frameSlow;
        });
        
        case "slow" | "speed" | "frame" | "f":
        response = ["Invalid command format!"];
        
        case "shot" | "screenshot" | "screen" | "ss" | "snap" | "snapshot":
        if (lastFrame != null) {
          var enc = new sk.thenet.format.bmp.PNG();
          remote.sendFile(enc.encode(lastFrame));
        } else {
          response = ["No frame known!"];
        }
        
        case _:
        response = ["Unknown command!"];
      }
      if (showCommand) {
        history.push("> " + trimmed);
      }
      history = history.concat(response);
      renderHistory();
      "";
      
      case Backspace:
      command.substr(0, FM.maxI(command.length - 1, 0));
      
      case _:
      command + Keyboard.getCharacter(e.key);
    });
    return true;
  }
  
  private function tick():Void {
    if (surface == null) {
      return;
    }
    if (applicationTick) {
      lastFrame = Platform.createBitmap(
          surface.bitmap.width, surface.bitmap.height, 0
        );
      lastFrame.blitAlpha(surface.bitmap, 0, 0);
    }
    if (!show && lastFrame != null && !applicationTick) {
      surface.bitmap.fill(0);
      surface.bitmap.blitAlpha(lastFrame, 0, 0);
    }
    if (show) {
      if (!applicationTick) {
        surface.bitmap.blitAlpha(lastFrame, 0, 0);
      }
      surface.bitmap.blitAlpha(bg, 0, 0);
      surface.bitmap.blitAlpha(historyCache, 0, 0);
      font.render(surface.bitmap, 0, height - 12, "> " + command + "_");
    }
    applicationTick = (if (pause) {
        false;
      } else if (frameSlow != 0) {
        frameCount == 0;
      } else {
        true;
      });
    if (frameSlow != 0) {
      frameCount++;
      frameCount %= frameSlow;
    }
  }
}
