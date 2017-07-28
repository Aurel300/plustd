package sk.thenet.event;

import haxe.io.Bytes;

/**
##Events - File##

Event name: `file`

This event is fired whenever a source produces a file. Reading the `data`
property causes the file to be read.
 */
class EFile extends Event {
  public var name(default, null):String;
  public var data(get, never):Bytes;
  
  private var dataFunc:Void->Bytes;
  
  private inline function get_data():Bytes {
    return dataFunc();
  }
  
  public function new(source:Source, name:String, dataFunc:Void->Bytes) {
    super(source, "file");
    this.name = name;
    this.dataFunc = dataFunc;
  }
}
