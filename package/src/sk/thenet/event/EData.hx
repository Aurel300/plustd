package sk.thenet.event;

import haxe.io.Bytes;

/**
##Events - Data##

Event name: `data`

This event is fired whenever a source produces binary data / data becomes
available.
 */
class EData extends Event {
  public var data(default, null):Bytes;
  
  public function new(source:Source, data:Bytes) {
    super(source, "data");
    this.data = data;
  }
}
