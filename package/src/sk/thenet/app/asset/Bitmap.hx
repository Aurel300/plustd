package sk.thenet.app.asset;

import haxe.io.Bytes;
import sk.thenet.app.Asset;
import sk.thenet.plat.Bitmap as PlatformBitmap;

class Bitmap extends Asset {
  public var current(default, null):PlatformBitmap;
  
  public function new(filename:String, initial:PlatformBitmap){
    super(filename, AssetType.Bitmap);
    current = initial;
  }
  
  override public function update(data:Bytes):Void {
    
  }
}
