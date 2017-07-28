package sk.thenet.event;

/**
##Events - Tick##

Event name: `tick`

This event is fired every frame, once `sk.thenet.plat.Platform.initFramerate()`
has been called.
 */
class ETick extends Event {
  public function new(source:Source) {
    super(source, "tick");
  }
}
