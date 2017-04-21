package sk.thenet.event;

/**
##Event##

Base class for events. Subclasses are generally used, because they allow
storing additional information in the event object.
 */
class Event {
  public var source(default, null):Source;
  public var type  (default, null):String;
  
  public function new(source:Source, type:String){
    this.source = source;
    this.type   = type;
  }
}
