package sk.thenet.app.asset;

import haxe.io.Bytes;
import sk.thenet.app.Asset;
import sk.thenet.format.bmp.PNG;
import sk.thenet.plat.Bitmap as PlatformBitmap;
import sk.thenet.plat.Platform;

class Bitmap extends Asset {
  private static var png:PNG = new PNG();
  
  public var current(default, null):PlatformBitmap;
  
  public function new(id:String, ?filename:String, ?initial:PlatformBitmap){
    super(AssetType.Bitmap, id, filename);
    if (initial == null){
      current = Platform.createBitmap(1, 1, 0);
    } else {
      current = initial;
    }
  }
  
  override public function update(data:Bytes):Void {
    if (filename.substr(-4) == ".png"){
      current = png.decode(data);
    } else {
      throw "unknown filetype";
    }
  }
}
