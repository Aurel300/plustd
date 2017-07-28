package sk.thenet.plat.cppsdl.common;

#if macro

import haxe.io.Path;
import haxe.macro.Expr;
import haxe.macro.Context;

class SDLMacro {
  private static var sdlPathInclude:String;
  private static var sdlPathLib:String;
  
  private static function initPath(?rel:String):Void {
    if (sdlPathInclude == null) {
      var pos = Context.currentPos();
      var sdlPath = Path.directory(Context.getPosInfos(pos).file);
      sdlPath = Path.normalize(Path.join([
           (Path.isAbsolute(sdlPath) ? "" : Sys.getCwd())
          ,sdlPath
          ,(rel == null ? "" : rel)
          ,"../../../../../../"
        ]));
      sdlPathInclude = Path.normalize(Path.join([
          sdlPath, "include/SDL2/"
        ]));
      if (Context.definedValue("PLUSTD_OS") == "osx") {
        sdlPathLib = Path.normalize(Path.join([
            sdlPath, "lib/osx/"
          ]));
      }
    }
  }
  
  public static macro function master(?rel:String):Array<Field> {
    initPath(rel);
    
    var cls  = Context.getLocalClass().get();
    var pos  = Context.currentPos();
    
    cls.meta.add(":buildXml", [{expr: EConst(CString('<target id="haxe">'
      + (switch (Context.definedValue("PLUSTD_OS")) {
      case "osx": '
  <flag value="-I${sdlPathInclude}" />
  <flag value="-D_THREAD_SAFE" />
  <flag value="-lSDL2" />
  <flag value="-lSDL2_image" />
  <flag value="-lSDL2_mixer" />
  <flag value="-L${sdlPathLib}" />
  <vflag name="-framework" value="OpenGL" />
  <vflag name="-framework" value="Cocoa" />';
      case _: "";
    }) + '
</target>')), pos: pos}], pos);
    cls.meta.add(":headerCode", [{expr: EConst(CString('#include "${sdlPathInclude}/SDL.h"
#include "${sdlPathInclude}/SDL_image.h"
#include "${sdlPathInclude}/SDL_mixer.h"')), pos: pos}], pos);
    cls.meta.add(":include", [{expr: EConst(CString('${sdlPathInclude}/SDL.h')), pos: pos}], pos);
    cls.meta.add(":include", [{expr: EConst(CString('${sdlPathInclude}/SDL_image.h')), pos: pos}], pos);
    cls.meta.add(":include", [{expr: EConst(CString('${sdlPathInclude}/SDL_mixer.h')), pos: pos}], pos);
    cls.meta.add(":cppFileCode", [{expr: EConst(CString("#undef main")), pos: pos}], pos);
    
    var fields = Context.getBuildFields();
    //sk.thenet.M.touchFields(fields);
    return fields;
  }
  
  public static macro function slave(?rel:String):Array<Field> {
    initPath(rel);
    
    var cls  = Context.getLocalClass().get();
    var pos  = Context.currentPos();
    
    cls.meta.add(":headerCode", [{expr: EConst(CString('#include "${sdlPathInclude}/SDL.h"
#include "${sdlPathInclude}/SDL_image.h"
#include "${sdlPathInclude}/SDL_mixer.h"')), pos: pos}], pos);
    cls.meta.add(":include", [{expr: EConst(CString('${sdlPathInclude}/SDL.h')), pos: pos}], pos);
    cls.meta.add(":include", [{expr: EConst(CString('${sdlPathInclude}/SDL_image.h')), pos: pos}], pos);
    cls.meta.add(":include", [{expr: EConst(CString('${sdlPathInclude}/SDL_mixer.h')), pos: pos}], pos);
    
    var fields = Context.getBuildFields();
    //sk.thenet.M.touchFields(fields);
    return fields;
  }
}

#end
