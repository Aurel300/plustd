package sk.thenet.app.asset;

import haxe.io.Bytes;
import sk.thenet.app.Asset;
import sk.thenet.plat.Platform;

/**
##Asset - Binary##
 */
class Binary extends Asset {  
  /**
The current data.
   */
  public var current(default, null):Bytes;
  
  public function new(id:String, ?filename:String, ?initial:Bytes) {
    super(AssetType.Binary, id, filename);
    current = initial;
    status = Loaded;
    /*
    if (initial == null) {
      status = Loading(0);
    } else {
      status = Loaded;
    }*/
  }
  
  override public function update(data:Bytes):Void {
    current = data;
    status = Loaded;
    super.update(null);
    manager.updateLoad(id);
  }
}
