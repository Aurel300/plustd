package sk.thenet.app;

/**
##Mouse##

Base class for mouse handler implementations. Generally accessible through
`sk.thenet.plat.Platform.mouse` or `sk.thenet.app.Application.mouse`,
if using the application class.

If the application surface was initialised with a scaling factor, the
coordinates in `Mouse.x` and `Mouse.y` contains the adjusted coordinates,
not the raw surface coordinates.

@see `sk.thenet.event.EMEvent`
 */
class Mouse {
  /**
The x coordinate of the mouse, in pixels.
   */
  public var x(default, null):Int = 0;
  
  /**
The y coordinate of the mouse, in pixels.
   */
  public var y(default, null):Int = 0;
  
  /**
`true` iff the mouse button is currently pressed down.
   */
  public var held(default, null):Bool = false;
  
  private function new(){}
}
