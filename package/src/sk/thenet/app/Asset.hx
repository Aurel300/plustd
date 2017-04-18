package sk.thenet.app;

import haxe.io.Bytes;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.Embed;
import sk.thenet.plat.Platform;

class Asset {
  public var type    (default, null):AssetType;
  public var id      (default, null):String;
  public var filename(default, null):String;
  public var status  (default, null):AssetStatus = AssetStatus.None;
  
  public function new(type:AssetType, id:String, ?filename:String){
    this.type     = type;
    this.id       = id;
    this.filename = filename;
  }
  
  public function update(data:Bytes):Void {}
}

enum AssetStatus {
  None;
  Error(msg:String);
  Loading(completion:Float);
  Loaded;
  Reloading(completion:Float);
}

enum AssetType {
  Bind;
  Bitmap;
  Sound;
}
