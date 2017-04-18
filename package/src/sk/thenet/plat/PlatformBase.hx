package sk.thenet.plat;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
Extending this class ensures platforms have the correct static fields declared.

@see `sk.thenet.plat.Platform`
 */
@:autoBuild(sk.thenet.plat.PlatformBase.check())
class PlatformBase {
  @:dox(hide)
  public static macro function check():Array<Field> {
    //return null;
    
    function sameTypes(a:ComplexType, tb:TypePath):Bool {
      switch (a){
        case TPath(ta):
        if (ta.name != tb.name) return false;
        if (ta.pack.length != tb.pack.length) return false;
        for (i in 0...ta.pack.length){
          if (ta.pack[i] != tb.pack[i]) return false;
        }
        return true;
        case _: return false;
      }
    }
    
    var fields = Context.getBuildFields();
    var modified = false;
    var fieldNames = new Map<String, Field>();
    var className = (switch (Context.getLocalType()){
      case TInst(ref, _): ref.toString();
      case _: "unknown";
    });
    for (f in fields){
      fieldNames.set(f.name, f);
    }
    for (init in [{
         name: "initFramerate"
        ,args: [
          {type: {name: "Float", pack: [], params: []}, optional: false, value: null}
        ]
        ,ret: {name: "Void", pack: [], params: []}
        ,retStrict: true
      }, {
         name: "initKeyboard"
        ,args: []
        ,ret: {name: "Keyboard", pack: ["sk", "thenet", "app"], params: []}
        ,retStrict: false
      }, {
         name: "initMouse"
        ,args: []
        ,ret: {name: "Mouse", pack: ["sk", "thenet", "app"], params: []}
        ,retStrict: false
      }, {
         name: "initSurface"
        ,args: [
           {type: {name: "Int", pack: [], params: []}, optional: false, value: null}
          ,{type: {name: "Int", pack: [], params: []}, optional: false, value: null}
          ,{type: {name: "Int", pack: [], params: []}, optional: true, value: {
                expr: EConst(CInt("0"))
               ,pos: Context.currentPos()
             }}
        ]
        ,ret: {name: "Surface", pack: ["sk", "thenet", "bmp"], params: []}
        ,retStrict: false
      }, {
         name: "initWindow"
        ,args: [
           {type: {name: "String", pack: [], params: []}, optional: false, value: null}
          ,{type: {name: "Int", pack: [], params: []}, optional: false, value: null}
          ,{type: {name: "Int", pack: [], params: []}, optional: false, value: null}
        ]
        ,ret: {name: "Void", pack: [], params: []}
        ,retStrict: true
      }, {
         name: "createSocket"
        ,args: []
        ,ret: {name: "Socket", pack: ["sk", "thenet", "net"], params: []}
        ,retStrict: false
      }, {
         name: "createWebsocket"
        ,args: []
        ,ret: {name: "Websocket", pack: ["sk", "thenet", "net", "ws"], params: []}
        ,retStrict: false
      }]){
      if (fieldNames.exists(init.name)){
        var field = fieldNames.get(init.name);
        switch (field.kind){
          case FFun(func):
          if (init.retStrict && !sameTypes(func.ret, init.ret)){
            throw init.name + " has incorrect return type in " + className;
          }
          var argn:Int = 0;
          for (arg in func.args){
            if (!sameTypes(arg.type, init.args[argn].type)){
              throw init.name + " has incorrect arg type in " + className;
            }
            if (arg.opt != init.args[argn].optional){
              if (arg.opt){
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
                  ,type: TPath(arg.type)
                  ,opt: arg.optional
                  ,value: (arg.optional ? arg.value : null)
                } ]
              ,expr: {
                 expr: EBlock([{
                   expr: EThrow({
                     expr: EConst(CString("unsupported operation"))
                    ,pos: Context.currentPos()
                  })
                  ,pos: Context.currentPos()
                }])
                ,pos: Context.currentPos()
              }
              ,params: []
              ,ret: TPath(init.ret)
            })
            ,pos: Context.currentPos()
          });
      }
    }
    for (support in [
         "isKeyboardCapable"
        ,"isMouseCapable"
        ,"isRealtimeCapable"
        ,"isSocketCapable"
        ,"isSocketServerCapable"
        ,"isSurfaceCapable"
        ,"isWebsocketCapable"
        ,"isWindowCapable"
        ,"keyboard"
        ,"mouse"
        ,"source"
      ]){
      if (fieldNames.exists(support)){
        var field = fieldNames.get(support);
        if (field.access.indexOf(AStatic) == -1){
          throw support + " must be static in " + className;
        }
        if (field.access.indexOf(APublic) == -1){
          throw support + " must be public in " + className;
        }
        switch (field.kind){
          case FProp(_, _, _, _):
          case _:
          throw support + " must be a property in " + className;
        }
      } else {
        modified = true;
        var tp = (switch(support){
            case "keyboard": {
                 name: "Keyboard"
                ,pack: ["sk", "thenet", "app"]
                ,params: []
              };
            case "mouse": {
                 name: "Mouse"
                ,pack: ["sk", "thenet", "app"]
                ,params: []
              };
            case "source": {
                 name: "Source"
                ,pack: ["sk", "thenet", "event"]
                ,params: []
              };
            case _: {
                 name: "Bool"
                ,pack: []
                ,params: []
              };
          });
        var np = (switch (support){
            case "source": {
                 expr: ENew({
                     name: "Source"
                    ,pack: ["sk", "thenet", "event"]
                    ,params: []
                  }, [])
                ,pos: Context.currentPos()
              };
            case "keyboard" | "mouse": {
                 expr: EConst(CIdent("null"))
                ,pos: Context.currentPos()
              };
            case _: {
                 expr: EConst(CIdent("false"))
                ,pos: Context.currentPos()
              };
          });
        fields.push({
             name: support
            ,doc: null
            ,meta: []
            ,access: [AStatic, APublic]
            ,kind: FProp(
                 "default"
                ,"never"
                ,TPath(tp)
                ,np
              )
            ,pos: Context.currentPos()
          });
      }
    }
    if (modified){
      return fields;
    }
    return null;
  }
}
