package sk.thenet.plat.flash.app;

import haxe.macro.Context;
import haxe.macro.Expr;

/**
Flash implementation of `sk.thenet.app.Embed`.

@see `sk.thenet.app.Embed`
 */
class Embed {
  private static var counter:Int = 0;
  
  public static macro function getBinary(
    id:ExprOf<String>, file:ExprOf<String>
  ):Expr {
    var ctype:TypeDefinition = {
         fields: []
        //,isExtern: false
        ,kind: TypeDefKind.TDClass({
             name: "ByteArray"
            ,pack: ["flash", "utils"]
            //,params
            //,sub
          }, [], false)
        ,meta: [{
             name: ":file"
            ,params: [macro $file]
            ,pos: Context.currentPos()
          }]
        ,name: "EmbeddedBinary" + counter
        ,pack: []
        //,params: []
        ,pos: Context.currentPos()
      };
    Context.defineType(ctype);
    var ctpath:TypePath = {
         name: "EmbeddedBinary" + counter++
        ,pack: []
        //,params
        //,sub
      };
    return macro {
      new sk.thenet.app.asset.Binary(
          $id, $file, sk.thenet.plat.flash.Platform.createBinaryNative(new $ctpath())
        );
    };
  }
  
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
      new sk.thenet.app.asset.Bitmap(
          $id, $file, sk.thenet.plat.flash.Platform.createBitmapNative(new $ctpath(0, 0))
        );
    };
  }
  
  public static macro function getSound(
    id:ExprOf<String>, file:ExprOf<String>
  ):Expr {
    var ctype:TypeDefinition = {
         fields: []
        ,kind: TypeDefKind.TDClass({
             name: "Sound"
            ,pack: ["flash", "media"]
          }, [], false)
        ,meta: [{
             name: ":sound"
            ,params: [macro $file]
            ,pos: Context.currentPos()
          }]
        ,name: "EmbeddedSound" + counter
        ,pack: []
        ,pos: Context.currentPos()
      };
    Context.defineType(ctype);
    var ctpath:TypePath = {
         name: "EmbeddedSound" + counter++
        ,pack: []
      };
    return macro {
      new sk.thenet.app.asset.Sound(
          $id, $file, sk.thenet.plat.flash.Platform.createSoundNative(new $ctpath())
        );
    };
  }
}
