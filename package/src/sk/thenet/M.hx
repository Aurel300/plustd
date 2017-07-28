package sk.thenet;

#if macro

import haxe.macro.Expr;
import haxe.macro.Compiler;
import haxe.macro.Context;

#end

class M {
  public static macro function denull(value:Expr, def:Expr):Expr {
    return macro ($value != null ? $value : $def);
  }
  
#if macro
  public static function touchFields(fields:Array<Field>):Void {
    fields.push({
         name: "__touch"
        ,pos: Context.currentPos()
        ,doc: null
        ,meta: []
        ,access: [APrivate, AStatic, AInline]
        ,kind: FVar(macro : String, macro $v{Std.string(Date.now().getTime())})
      });
  }
  
  public static macro function touch():Array<Field> {
    var fields = Context.getBuildFields();
    touchFields(fields);
    return fields;
  }
  
  public static macro function init():Void {
    var buildStart = Date.now();
    
    /*
    Sys.println(" ┏━┓  ┏┓   ┏┓ ┏┓"); // hmm
    Sys.println("┏┛ ┗┳━┫┣┳┳━┫┗┳┻┃");
    Sys.println("┗┓ ┏┫╋┃┃┃┣┓┃┏┫╋┃");
    Sys.println(" ┗━┛┃┳┻┻━┻━┻━┻━┛");
    Sys.println("    ┗┛");
    */
    inline function esc(str:String):String {
      return String.fromCharCode(0x1B) + "[" + str + "m";
    }
    inline function rst():String {
      return esc("0");
    }
    
    inline function log(msg:String):Void {
      Sys.println('${esc("38;7")} ╋ std ${esc("1;40;37")} $msg ${rst()}');
    }
    inline function logWarning(msg:String):Void {
      Sys.println('${esc("38;43;7")} ╋ std ${esc("1;40;33")} Warning ${esc("1;40;37")} $msg ${rst()}');
    }
    inline function logError(msg:String, ?abort:Bool = false):Void {
      Sys.println('${esc("38;41;7")} ╋ std ${esc("1;40;31;5")}  Error  ${esc("1;40;37;25")} $msg ${rst()}');
      if (abort) {
        Sys.println("");
        Context.error("abort", Context.currentPos());
      }
    }
    
    var rainbow = [1, 5, 4, 6, 2, 3, 7];
    
    Sys.println("");
    
    var lines = [
         [' ',' ',' ','┏','━','━','━','━','━','┓',' ',' ',' ','┏','┓',' ',' ',' ','┏','┓',' ','┏','┓',' ']
        ,[' ','┏','━','┛',' ',' ',' ',' ',' ','┗','━','┳','━','┫','┣','┳','┳','━','┫','┗','┳','┛','┃',' ']
        ,[' ','┃',' ',' ',' ',' ',' ',' ',' ',' ',' ','┃','┃','┃','┃','┃','┃','┗','┫','┏','┫','┃','┃',' ']
        ,[' ','┃',' ',' ',' ',' ',' ',' ',' ',' ',' ','┃','╋','┃','┃','┃','┣','┓','┃','┣','┫','╋','┃',' ']
        ,[' ','┗','━','┓',' ',' ',' ',' ',' ','┏','━','┫','┏','┻','┻','━','┻','━','┻','━','┻','━','┛',' ']
        ,[' ',' ',' ','┗','━','━','━','━','━','┛',' ','┗','┛',' ','t','h','e','n','e','t','.','s','k',' ']
      ];
    var ly:Int = 0;
    for (l in lines) {
      var lc = ly >> 1;
      Sys.print(esc("1;30;4" + lc));
      for (c in 0...24) {
        var olc = lc;
        lc = (ly >> 1) + (c >> 3) + ((ly + c) % 4 < 2 ? 1 : 0);
        if (lc != olc) {
          Sys.print(esc("4" + rainbow[lc]));
        }
        Sys.print(l[c]);
      }
      Sys.println(rst());
      ly++;
    }
    /*
    Sys.println(' ${esc("30;43;5")}     ┏━━━━━┓   ┏┓   ┏┓ ┏┓ ${rst()}');
    Sys.println('  ${esc("30;42;5")}  ┏━┛     ┗━┳━┫┣┳┳━┫┗┳┛┃ ${rst()}');
    Sys.println('   ${esc("30;46;5")} ┃         ┃┃┃┃┃┃┗┫┏┫┃┃ ${rst()}');
    Sys.println(' ${esc("30;44;5")}   ┃         ┃╋┃┃┃┣┓┃┣┫╋┃ ${rst()}');
    Sys.println('  ${esc("30;45;5")}  ┗━┓     ┏━┫┏┻┻━┻━┻━┻━┛ ${rst()}');
    Sys.println('${esc("30;41;5")}      ┗━━━━━┛ ┗┛ thenet.sk ${rst()}');
    */
    
    /*
    Sys.println(' ${esc("30;43;5")}     ┏━━━━━┓   ┏┓   ┏┓ ┏┓ ${rst()}');
    Sys.println('  ${esc("30;42;5")}  ┏━┛     ┗━┳━┫┣┳┳━┫┗┳┛┃ ${rst()}');
    Sys.println('   ${esc("30;46;5")} ┃         ┃┃┃┃┃┃┗┫┏┫┃┃ ${rst()}');
    Sys.println(' ${esc("30;44;5")}   ┃         ┃╋┃┃┃┣┓┃┣┫╋┃ ${rst()}');
    Sys.println('  ${esc("30;45;5")}  ┗━┓     ┏━┫┏┻┻━┻━┻━┻━┛ ${rst()}');
    Sys.println('${esc("30;41;5")}      ┗━━━━━┛ ┗┛ thenet.sk ${rst()}');
    */
    //Sys.println("");
    
    var platformId = "";
    switch (Context.definedValue("PLUSTD_TARGET")) {
      case "cppsdl.desktop" | "cppsdl.phone" | "flash"
        | "js.canvas" | "js.webgl" | "neko":
      platformId = Context.definedValue("PLUSTD_TARGET");
      
      case _:
      if (Context.definedValue("PLUSTD_TARGET") != null) {
        logWarning("Unknown target platform specified.");
      } else {
        logWarning("No target platform specified. Please use -D PLUSTD_TARGET.");
      }
      platformId = (switch (Compiler.getOutput()) {
        case _.substr(-4) => ".cpp": "cppsdl.desktop";
        case _.substr(-4) => ".swf": "flash";
        case _.substr(-3) => ".js": "js.canvas";
        case _.substr(-2) => ".n": "neko";
        
        case _:
        logError("Cannot guess target platform!", true);
        "";
      });
      logWarning("Platform guessed based on output extension.");
    }
    
    var platformOS = "";
    var platformOSId = "";
    
    platformOS = (switch (platformId) {
      case "cppsdl.desktop":
      switch (Context.definedValue("PLUSTD_OS")) {
        case "osx" | "win" | "linux":
        platformOSId = Context.definedValue("PLUSTD_OS");
        
        case _:
        if (Context.definedValue("PLUSTD_OS") != null) {
          logWarning("Unknown target OS specified.");
        } else {
          logWarning("No target OS specified. Please use -D PLUSTD_OS.");
        }
        platformOSId = (switch (Sys.systemName()) {
          case "Mac": "osx";
          case "Windows": "win";
          case "Linux": "linux";
          
          case _:
          logError("Incompatible build platform for C++ / SDL!", true);
          "";
        });
        logWarning("OS guessed based on build OS.");
      }
      (switch (platformOSId) {
        case "osx": "OS X";
        case "win": "Windows";
        case "linux": "Linux";
        case _: "Unknown";
      });
      
      case "cppsdl.phone":
      switch (Context.definedValue("PLUSTD_OS")) {
        case "ios" | "android":
        platformOSId = Context.definedValue("PLUSTD_OS");
        
        case _:
        if (Context.definedValue("PLUSTD_OS") != null) {
          logError("Unknown target OS specified.", true);
        } else {
          logError("No target OS specified. Please use -D PLUSTD_OS.", true);
        }
      }
      (switch (platformOSId) {
        case "ios": "iOS";
        case "android": "Android";
        case _: "Unknown";
      });
      
      case _: "";
    });
    
    Compiler.define("PLUSTD_TARGET", platformId);
    Compiler.define("PLUSTD_OS", platformOSId);
    
    var platformName = (switch (platformId) {
      case "cppsdl.desktop": "C++ / SDL / Desktop";
      case "cppsdl.phone":   "C++ / SDL / Phone";
      case "flash":          "Adobe Flash";
      case "js.canvas":      "JavaScript / Canvas";
      case "js.webgl":       "JavaScript / WebGL";
      case "neko":           "Neko VM";
      case _:                "Unknown";
    });
    
    log("Target platform: " + platformName);
    if (platformOS != "") {
      log("Target OS:       " + platformOS);
    }
    log("Target output:   " + Compiler.getOutput());
    
    switch (platformId) {
      case "cppsdl.phone":
      Compiler.define("no-compilation");
    }
    
    //Context.onAfterTyping((_) -> log("onAfterTyping"));
    //Context.onGenerate((_) -> log("onGenerate"));
    Context.onAfterGenerate(function() {
        var buildEnd = Date.now();
        var secs = Std.int((buildEnd.getTime() - buildStart.getTime()) / 1000);
        var mins = 0;
        var hrs  = 0;
        if (secs >= 60) {
          mins = Std.int(secs / 60);
          secs = secs % 60;
        }
        if (mins >= 60) {
          hrs = Std.int(mins / 60);
          mins = mins % 60;
        }
        var diff
          = (hrs > 0 ? '$hrs hours, ' : "")
          + (mins > 0 || hrs > 0 ? '$mins minutes, ' : "")
          + '$secs seconds';
        log('Build complete in: $diff');
        Sys.println("");
      });
  }
#end
}
