package sk.thenet.plat.cppsdl.common.app;

#if cpp

import haxe.io.Bytes;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.audio.Sound;
import sk.thenet.bmp.Bitmap;
import sk.thenet.format.bmp.PNG;
import sk.thenet.plat.cppsdl.common.SDL;
import sk.thenet.plat.cppsdl.common.SDL.RWOpsPointer;

/**
C++ / SDL implementation of `sk.thenet.app.Embed`.

@see `sk.thenet.app.Embed`
 */
@:build(sk.thenet.plat.cppsdl.common.SDLMacro.slave("../"))
class Embed {
  private static var png:PNG = new PNG();
  // private static var wav:WAV = new WAV(); // one day?
  
  private static function getFile(file:String):Bytes {
    var rw = SDL.RWFromFile(file, "rb");
    if (untyped __cpp__("{0} == NULL", rw)){
      trace(SDL.getError());
      throw "SDL error";
    }
    var size = SDL.RWsize(rw);
    var data = Bytes.alloc(size);
    var read = 0;
    while (read < size){
      read += SDL.RWread(
          rw, cpp.Pointer.arrayElem(data.getData(), read), 1, size - read
        );
    }
    SDL.RWclose(rw);
    return data;
  }
  
  public static function getBitmap(id:String, file:String):AssetBitmap {
    var ret = new AssetBitmap(id, file);
    ret.preload = function():Void {
      var data = getFile(file);
      var bmp = png.decode(data);
      ret.updateBitmap(bmp);
    };
    return ret;
  }
  
  public static function getSound(id:String, file:String):AssetSound {
    var ret = new AssetSound(id, file);
    Sound.init();
    ret.preload = function():Void {
      var data = getFile(file);
      var dataOps = SDL.RWFromConstMem(
           cpp.Pointer.ofArray(data.getData())
          ,data.length
        );
      var chunk = SDL.Mixer.loadWAV_RW(dataOps, 0);
      var sound = new Sound(chunk);
      if (untyped __cpp__("{0} == NULL", chunk)){
        trace(SDL.Mixer.getError(), id, file);
        //throw "SDL error";
      }
      ret.updateSound(sound);
    };
    return ret;
  }
}

#end
