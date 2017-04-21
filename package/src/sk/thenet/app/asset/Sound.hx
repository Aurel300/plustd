package sk.thenet.app.asset;

import haxe.io.Bytes;
import sk.thenet.app.Asset;
import sk.thenet.format.bmp.PNG;
import sk.thenet.audio.Sound as PlatformSound;
import sk.thenet.plat.Platform;

/**
##Asset - Sound##

A sound sample asset. Currently sound samples cannot be hot reloaded.
 */
class Sound extends Asset {
  public var current(default, null):PlatformSound;
  
  /**
Creates a new sound sample asset with the given `id`.
   */
  public function new(id:String, ?filename:String, ?initial:PlatformSound){
    super(AssetType.Sound, id, filename);
    if (initial == null){
      status = Loading(0);
    } else {
      current = initial;
      status = Loaded;
    }
  }
  
  override public function update(data:Bytes):Void {
    //throw "unknown filetype";
  }
  
  public function updateSound(data:PlatformSound):Void {
    current = data;
    status = Loaded;
    super.update(null);
    manager.updateLoad(id);
  }
}
