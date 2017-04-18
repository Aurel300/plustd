package sk.thenet.plat.flash.app;

import haxe.macro.Context;
import haxe.macro.Expr;

class Embed {
  private static var counter:Int = 0;
  
  public static macro function getBitmap(
    id:ExprOf<String>, file:ExprOf<String>
  ):Expr {
    var ctype:TypeDefinition = {
         fields: []
        //,isExtern: false
        ,kind: TypeDefKind.TDClass({
             name: "BitmapData"
            ,pack: ["flash", "display"]
            //,params
            //,sub
          }, [], false)
        ,meta: [{
             name: ":bitmap"
            ,params: [macro $file]
            ,pos: Context.currentPos()
          }]
        ,name: "EmbeddedBitmap" + counter
        ,pack: []
        //,params: []
        ,pos: Context.currentPos()
      };
    Context.defineType(ctype);
    var ctpath:TypePath = {
         name: "EmbeddedBitmap" + counter++
        ,pack: []
        //,params
        //,sub
      };
    return macro {
      new AssetBitmap(
          $id, $file, Platform.createBitmapFlash(new $ctpath(0, 0))
        );
    };
  }
}
