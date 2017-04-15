package sk.thenet.app;

import sk.thenet.app.Keyboard.Key;

/**
##Application - State##

Base class for representing individual application states. Subclasses should
override relevant handlers and the `to()` and `from()` methods to define the
desired behaviour.

@see `sk.thenet.app.Application`
 */
class State implements sk.thenet.fsm.State {
  public var id(default, null):String;
  
  /**
Used to access the `sk.thenet.app.Application` from within states.
   */
  public var app(default, null):Application;
  
  /**
@param id The name given to this state. Once added to the application, it will
be accessible with `app.getStateById(id)`.
@param app The application to which this state belongs to.
   */
  public function new(id:String, app:Application){
    this.id = id;
    this.app = app;
  }
  
  /**
Called when this state is entered.
   */
  public function to():Void {}
  
  /**
Called before this state is left.
   */
  public function from():Void {}
  
  /**
Called at each tick.

Pre-requisite is `sk.thenet.app.ApplicationInit.Framerate` passed to
application initialisation.
   */
  public function tick():Void {}
  
  /**
Called when the mouse is clicked.

Pre-requisite is `sk.thenet.app.ApplicationInit.Mouse` passed to
application initialisation.

@see `sk.thenet.event.EMEvent`
   */
  public function mouseClick(x:Int, y:Int):Void {}
  
  /**
Called when the mouse is pressed down.

Pre-requisite is `sk.thenet.app.ApplicationInit.Mouse` passed to
application initialisation.

@see `sk.thenet.event.EMEvent`
   */
  public function mouseDown(x:Int, y:Int):Void {}
  
  /**
Called when the mouse is released.

Pre-requisite is `sk.thenet.app.ApplicationInit.Mouse` passed to
application initialisation.

@see `sk.thenet.event.EMEvent`
   */
  public function mouseUp(x:Int, y:Int):Void {}
  
  /**
Called when the mouse is moved.

Pre-requisite is `sk.thenet.app.ApplicationInit.Mouse` passed to
application initialisation.

@see `sk.thenet.event.EMEvent`
   */
  public function mouseMove(x:Int, y:Int):Void {}
  
  /**
Called when a key is pressed down.

Pre-requisite is `sk.thenet.app.ApplicationInit.Keyboard` passed to
application initialisation.

@see `sk.thenet.event.EKEvent`
   */
  public function keyDown(key:Key):Void {}
  
  /**
Called when a key is released.

Pre-requisite is `sk.thenet.app.ApplicationInit.Keyboard` passed to
application initialisation.

@see `sk.thenet.event.EKEvent`
   */
  public function keyUp(key:Key):Void {}
}
