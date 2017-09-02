package sk.thenet.plat;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;

/**
Extending this class ensures platforms have the correct static fields declared.

@see `sk.thenet.plat.Platform`
 */
@:autoBuild(sk.thenet.plat.PlatformBase.check())
class PlatformBase {
  @:dox(hide)
  public static macro function check():Array<Field> {
    var fields = Context.getBuildFields();
    var modified = false;
    var fieldNames = new Map<String, Field>();
    var className = (switch (Context.getLocalType()) {
      case TInst(ref, _): ref.toString();
      case _: "unknown";
    });
    for (f in fields) {
      fieldNames.set(f.name, f);
    }
    for (init in [{
         name: "initFramerate"
        ,args: [
          {type: macro : Float, optional: false, value: null}
        ]
        ,ret: macro : Void
        ,retStrict: true
      }, {
         name: "initKeyboard"
        ,args: []
        ,ret: macro : sk.thenet.app.Keyboard
        ,retStrict: false
      }, {
         name: "initMouse"
        ,args: []
        ,ret: macro : sk.thenet.app.Mouse
        ,retStrict: false
      }, {
         name: "initSurface"
        ,args: [
           {type: macro : Int, optional: false, value: null}
          ,{type: macro : Int, optional: false, value: null}
          ,{type: macro : Int, optional: true, value: macro 0}
        ]
        ,ret: macro : sk.thenet.bmp.Surface
        ,retStrict: false
      }, {
         name: "initWindow"
        ,args: [
           {type: macro : String, optional: false, value: null}
          ,{type: macro : Int, optional: false, value: null}
          ,{type: macro : Int, optional: false, value: null}
        ]
        ,ret: macro : Void
        ,retStrict: true
      }, {
         name: "createBitmap"
        ,args: [
           {type: macro : Int, optional: false, value: null}
          ,{type: macro : Int, optional: false, value: null}
          ,{type: macro : sk.thenet.bmp.Colour, optional: false, value: null}
        ]
        ,ret: macro : sk.thenet.bmp.Bitmap
        ,retStrict: false
      }, {
         name: "createSocket"
        ,args: []
        ,ret: macro : sk.thenet.net.Socket
        ,retStrict: false
      }, {
         name: "createWebsocket"
        ,args: []
        ,ret: macro : sk.thenet.net.ws.Websocket
        ,retStrict: false
      }]) {
      if (fieldNames.exists(init.name)) {
        var field = fieldNames[init.name];
        switch (field.kind) {
          case FFun(func):
          if (init.retStrict && !func.ret.toType().unify(init.ret.toType())) {
            throw init.name + " has incorrect return type in " + className;
          }
          var argn:Int = 0;
          for (arg in func.args) {
            if (!arg.type.toType().unify(init.args[argn].type.toType())) {
              throw init.name + " has incorrect arg type in " + className;
            }
            if (arg.opt != init.args[argn].optional) {
              if (arg.opt) {
                throw init.name + " arg should be required in " + className;
              } else {
                throw init.name + " arg should be optional in " + className;
              }
            }
            argn++;
          }
          case _:
          throw init.name + " must be a method in " + className;
        }
      } else {
        modified = true;
        var argn:Int = 0;
        fields.push({
             name: init.name
            ,doc: null
            ,meta: []
            ,access: [AStatic, APublic, AInline]
            ,kind: FFun({
               args: [ for (arg in init.args) {
                   meta: []
                  ,name: "arg_" + (argn++)
                  ,type: arg.type
                  ,opt: arg.optional
                  ,value: arg.value
                } ]
              ,expr: macro throw "unsupported operation"
              ,params: []
              ,ret: init.ret
            })
            ,pos: Context.currentPos()
          });
      }
    }
    for (support in [
         "capabilities"
        ,"keyboard"
        ,"mouse"
        ,"source"
      ]) {
      if (fieldNames.exists(support)) {
        var field = fieldNames[support];
        if (field.access.indexOf(AStatic) == -1) {
          throw support + " must be static in " + className;
        }
        if (field.access.indexOf(APublic) == -1) {
          throw support + " must be public in " + className;
        }
        switch (field.kind) {
          case FProp(_, _, _, _):
          case _:
          throw support + " must be a property in " + className;
        }
      } else {
        modified = true;
        var tp = (switch(support) {
            case "capabilities": macro : sk.thenet.plat.Capabilities;
            case "keyboard": macro : sk.thenet.app.Keyboard;
            case "mouse": macro : sk.thenet.app.Mouse;
            case "source": macro : sk.thenet.event.Source;
            case _: macro : Bool;
          });
        var np = (switch (support) {
            case "capabilities": macro new sk.thenet.plat.Capabilities();
            case "keyboard" | "mouse": macro null;
            case "source": macro new sk.thenet.event.Source();
            case _: macro false;
          });
        fields.push({
             name: support
            ,doc: null
            ,meta: []
            ,access: [AStatic, APublic]
            ,kind: FProp(
                 "default"
                ,"never"
                ,tp
                ,np
              )
            ,pos: Context.currentPos()
          });
      }
    }
    if (modified) {
      return fields;
    }
    return null;
  }
}
