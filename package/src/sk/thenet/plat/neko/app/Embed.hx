package sk.thenet.plat.neko.app;

#if neko

import haxe.io.Bytes;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.bmp.Bitmap;
import sk.thenet.format.bmp.PNG;

/**
Neko implementation of `sk.thenet.app.Embed`.

@see `sk.thenet.app.Embed`
 */
class Embed {
  private static var png:PNG = new PNG();
  // private static var wav:WAV = new WAV(); // one day?
  
  public static function getBitmap(id:String, file:String):AssetBitmap {
    var ret = new AssetBitmap(id, file);
    ret.preload = function():Void {
      var data = sys.io.File.getBytes(file);
      var bmp = png.decode(data);
      ret.updateBitmap(bmp);
    };
    return ret;
  }
}

#end
