package sk.thenet.plat.cppsdl.common.format.bmp;

#if cpp

import haxe.io.Bytes;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.format.Format;
import sk.thenet.plat.cppsdl.common.SDL;
import sk.thenet.plat.cppsdl.common.SDL.RWOpsPointer;

@:build(sk.thenet.plat.cppsdl.common.SDLMacro.slave("../../"))
class PNG implements Format<Bitmap> {
  private static var init:Bool = false;
  
  public function new() {}
  
  public function encode(obj:Bitmap):Bytes {
    return (new sk.thenet.plat.common.format.bmp.PNG()).encode(obj);
  }
  
  public function decode(data:Bytes):Bitmap {
    if (!init) {
      SDL.Image.init(SDL.Image.INIT_PNG);
      init = true;
    }
    var dataOps = SDL.RWFromConstMem(
         cpp.Pointer.ofArray(data.getData())
        ,data.length
      );
    var png = SDL.Image.loadPNG_RW(dataOps);
    var ret = new Bitmap(
        png.width, png.height, SDL.createTextureFromSurface(Platform.ren, png)
      );
    SDL.freeSurface(png);
    return ret;
  }
}

#end
