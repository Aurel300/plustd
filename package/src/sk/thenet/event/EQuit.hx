package sk.thenet.event;

/**
##Events - Quit##

Event name: `quit`

This event is fired before the application is terminated.
 */
class EQuit extends Event {
  public function new(source:Source) {
    super(source, "quit");
  }
}
