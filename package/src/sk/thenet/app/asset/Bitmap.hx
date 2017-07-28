package sk.thenet.app.asset;

import haxe.io.Bytes;
import sk.thenet.app.Asset;
import sk.thenet.format.bmp.PNG;
import sk.thenet.bmp.Bitmap as PlatformBitmap;
import sk.thenet.plat.Platform;

/**
##Asset - Bitmap##

A 2D bitmap asset. Uses `PNG` internally to decode binary data.
 */
class Bitmap extends Asset {
  private static var png:PNG = new PNG();
  
  /**
The current bitmap of this asset.
   */
  public var current(default, null):PlatformBitmap;
  
  /**
Creates a new bitmap asset with the given `id`. If provided, the asset is linked
to the given `filename` (it will be reloaded if a change is detected to that
file and hot reloading is initialised).
   */
  public function new(id:String, ?filename:String, ?initial:PlatformBitmap) {
    super(AssetType.Bitmap, id, filename);
    current = initial;
    if (initial == null) {
      status = Loading(0);
    } else {
      status = Loaded;
    }
  }
  
  override public function update(data:Bytes):Void {
    if (filename.substr(-4) == ".png") {
      updateBitmap(png.decode(data));
    } else {
      throw "unknown filetype";
    }
  }
  
  public function updateBitmap(data:PlatformBitmap):Void {
    current = data;
    status = Loaded;
    super.update(null);
    manager.updateLoad(id);
  }
}
