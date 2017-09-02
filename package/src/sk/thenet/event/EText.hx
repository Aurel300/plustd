package sk.thenet.event;

/**
##Events - Text input event##
 */
class EText extends Event {
  /**
The string representation of this event, or null.
   */
  public var text(default, null):String;
  
  public function new(source:Source, text:String) {
    super(source, "text");
    this.text = text;
  }
}
