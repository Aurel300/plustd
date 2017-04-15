package sk.thenet.app;

import haxe.io.Bytes;

class Asset {
  public var filename(default, null):String;
  public var status  (default, null):AssetStatus = AssetStatus.None;
  public var type    (default, null):AssetType;
  
  public function new(filename:String, type:AssetType){
    this.filename = filename;
    this.type = type;
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
  Bitmap;
  Sound;
}
