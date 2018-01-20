package sk.thenet;

#if macro
import haxe.macro.Expr;
import haxe.macro.Compiler;
import haxe.macro.Context;
#end

import sk.thenet.geom.Point;

using StringTools;

class M {
  /**
Checks whether `value` is `null`. If so, the expression evaluates to `def`,
otherwise `value`.

Generates an expression at compile time.
   */
  public static macro function denull(value:Expr, def:Expr):Expr {
    return macro ($value != null ? $value : $def);
  }
  
  /**
Calls `func` iff `value` is not null. Evaluates to the result of the call if it
happened, `null` otherwise.

Generates an expression at compile time.
   */
  public static macro function callDenull(func:Expr, value:Expr):Expr {
    return macro {
        var res = $value;
        (res != null ? $func(res) : null);
      };
  }
  
  /**
Swaps `a` and `b` using a temporary variable.

Generates an expression at compile time.
   */
  public static macro function swap(a:Expr, b:Expr):Expr {
    return macro {
      var t = $a;
      $a = $b;
      $b = t;
    };
  }
  
#if macro
  private static function touchFields(fields:Array<Field>):Void {
    fields.push({
         name: "__touch"
        ,pos: Context.currentPos()
        ,doc: null
        ,meta: []
        ,access: [APrivate, AStatic, AInline]
        ,kind: FVar(macro : String, macro $v{Std.string(Date.now().getTime())})
      });
  }
  
  private static macro function touch():Array<Field> {
    var fields = Context.getBuildFields();
    touchFields(fields);
    return fields;
  }
  
  public static macro function traceType():Array<Field> {
    trace(Context.getBuildFields());
    return null;
  }
  
  @:dox(hide)
  public static macro function initApplication():Array<Field> {
    var fields = Context.getBuildFields();
    var hasMain = false;
    var hasFont = false;
    for (f in fields) {
      if (f.name == "main") hasMain = true;
      if (f.name == "consoleFont") hasFont = true;
    }
    var cname = Context.getLocalClass().get().name;
    var cpath = {name: cname, pack: [], params: []};
    var pos = Context.currentPos();
    if (!hasMain) {
      fields.push({
           access: [AStatic, APublic]
          ,doc: null
          ,kind: FFun({
             args: []
            ,expr: macro { sk.thenet.plat.Platform.boot(function() new $cpath()); }
            ,params: [], ret: null
          })
          ,meta: []
          ,name: "main"
          ,pos: pos
        });
    }
    if (!hasFont) {
      fields.push({
           access: [AStatic, APublic]
          ,doc: null
          ,kind: FVar(macro : sk.thenet.bmp.Font, null)
          ,meta: []
          ,name: "consoleFont"
          ,pos: pos
        });
    }
    return fields; 
  }
  
  @:dox(hide)
  public static macro function autoConstruct():Array<Field> {
    var fields = Context.getBuildFields();
    var code:Expr = null;
    for (f in fields) {
      if (f.name == "new") {
        switch (f.kind) {
          case FFun(fun):
          code = fun.expr;
          fields.remove(f);
          break;
          
          case _:
        }
      }
    }
    var args = [];
    var states = [ for (f in fields) switch (f.kind) {
        case FVar(t, _):
        args.push({name: f.name, type: t, opt: false, value: null});
        macro $p{["this", f.name]} = $i{f.name};
        
        case _:
        continue;
      } ];
    if (code != null) {
      states.push(code);
    }
    fields.push({
      name: "new",
      access: [APublic],
      pos: Context.currentPos(),
      kind: FFun({
        args: args,
        expr: macro $b{states},
        params: [],
        ret: null
      })
    });
    return fields;
  }
  
  @:dox(hide)
  public static function makeDocTypes():Void {
    for (t in [
        for (d in 2...4) for (c in ["I", "F"]) 'sk.thenet.geom.Point${d}D${c}'
      ]) {
      makeType(t, true);
    }
  }
  
  @:dox(hide)
  public static function makeType(type:String, define:Bool):TypeDefinition {
    if (!type.startsWith("sk.thenet.")) {
      return null;
    }
    var c = type.split(".");
    var ret = (switch (c) {
        case ["sk", "thenet", "geom", gp]:
        if (!Point.isPointClass(gp)) {
          null;
        } else {
          sk.thenet.geom.Point.buildPoint(
              gp.charCodeAt(5) - "0".code, gp.endsWith("DI")
            );
        }
        case _: null;
      });
    if (define) {
      Context.defineType(ret);
    }
    return ret;
  }
  
  @:dox(hide)
  public static macro function init():Void {
    var buildStart = Date.now();
    var quiet = Context.defined("PLUSTD_QUIET");
    
    inline function esc(str:String):String {
      return String.fromCharCode(0x1B) + "[" + str + "m";
    }
    inline function rst():String {
      return esc("0");
    }
    inline function log(msg:String):Void {
      if (!quiet) {
        Sys.println('${esc("38;7")} ╋ std ${esc("1;40;37")} $msg ${rst()}');
      }
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
    
    if (!quiet) {
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
      Sys.println(" ┏━┓  ┏┓   ┏┓ ┏┓"); // hmm
      Sys.println("┏┛ ┗┳━┫┣┳┳━┫┗┳┻┃");
      Sys.println("┗┓ ┏┫╋┃┃┃┣┓┃┏┫╋┃");
      Sys.println(" ┗━┛┃┳┻┻━┻━┻━┻━┛");
      Sys.println("    ┗┛");
      */
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
    }
    
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
    
    Context.onTypeNotFound(makeType.bind(_, false));
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
        if (!quiet) Sys.println("");
      });
  }
#end
}
