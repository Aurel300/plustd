package sk.thenet.format;

import haxe.io.Bytes;

class Archive {
  public var files:Array<ArchiveFile> = [];
  
  public function new() {}
  
  public function addData(data:Bytes, path:String):Void {
    files.push(new ArchiveFile(data, path));
  }
}

class ArchiveFile {
  public var data:Bytes;
  public var path:String;
  
  public function new(data:Bytes, path:String) {
    this.data = data;
    this.path = path;
  }
}
