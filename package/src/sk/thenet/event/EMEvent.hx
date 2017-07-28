package sk.thenet.event;

/**
##Events - Mouse event##

Base class for all mouse-related events.

If the application surface was initialised with a scaling factor, the
coordinates in `EMEvent.x` and `EMEvent.y` contains the adjusted coordinates,
not the raw surface coordinates.

@see `sk.thenet.app.Mouse`
@see `sk.thenet.event.EMClick`
@see `sk.thenet.event.EMDown`
@see `sk.thenet.event.EMMove`
@see `sk.thenet.event.EMUp`
 */
class EMEvent extends Event {
  /**
The x coordinate of the mouse event, in pixels.
   */
  public var x(default, null):Int;
  
  /**
The y coordinate of the mouse event, in pixels.
   */
  public var y(default, null):Int;
  
  public function new(source:Source, x:Int, y:Int, type:String) {
    super(source, type);
    this.x = x;
    this.y = y;
  }
}

/**
##Events - Mouse click##

Event name: `mclick`

This event is fired when the user clicks on the main surface, once
`sk.thenet.plat.Platform.initMouse()` has been called.
 */
class EMClick extends EMEvent {
  public function new(source:Source, x:Int, y:Int) {
    super(source, x, y, "mclick");
  }
}

/**
##Events - Mouse down##

Event name: `mdown`

This event is fired when the user presses down the mouse button on the
main surface, once `sk.thenet.plat.Platform.initMouse()` has been called.
 */
class EMDown extends EMEvent {
  public function new(source:Source, x:Int, y:Int) {
    super(source, x, y, "mdown");
  }
}

/**
##Events - Mouse up##

Event name: `mup`

This event is fired when the user releases the mouse button on the
main surface, once `sk.thenet.plat.Platform.initMouse()` has been called.
 */
class EMUp extends EMEvent {
  public function new(source:Source, x:Int, y:Int) {
    super(source, x, y, "mup");
  }
}

/**
##Events - Mouse move##

Event name: `mmove`

This event is fired when the user moves the mouse on the
main surface, once `sk.thenet.plat.Platform.initMouse()` has been called.
 */
class EMMove extends EMEvent {
  public function new(source:Source, x:Int, y:Int) {
    super(source, x, y, "mmove");
  }
}
