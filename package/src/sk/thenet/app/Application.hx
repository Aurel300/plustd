package sk.thenet.app;

import sk.thenet.event.*;
import sk.thenet.event.EMEvent.EMClick;
import sk.thenet.event.EMEvent.EMDown;
import sk.thenet.event.EMEvent.EMMove;
import sk.thenet.event.EMEvent.EMUp;
import sk.thenet.event.EKEvent.EKDown;
import sk.thenet.event.EKEvent.EKUp;
import sk.thenet.fsm.Machine as FSMMachine;
import sk.thenet.fsm.Memory as FSMMemory;
import sk.thenet.plat.Platform;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Surface;

/**
##Application##

Convenience class for stateful applications - different states have different
event and transition handling code.

To use `Application` as intended, extend it with `Main`. In the
constructor, pass the systems which should be initialised (see
`sk.thenet.app.ApplicationInit`) to `super()`. Then add the individual states
as subclasses of `sk.thenet.app.State` using the `addState()` method. The first
state passed is the default / initial state. Finally, call `mainLoop()`.

Note that the transitions are not used in this class. To change states, use
`Application.applyState`.
 */
@:keepSub
class Application
  implements FSMMachine<Application, State, Transition>
  implements FSMMemory<State>
{
  /**
State which is entered when `reset()` is called and when the `mainLoop()` is
entered.
   */
  public var initialState(default, null):State;
  
  /**
State which is currently handling events and running code.
   */
  public var currentState(default, null):State;
  
  /**
Main drawing surface, if initialised with `ApplicationInit` `Surface`.
   */
  public var surface(default, null):Surface;
  
  /**
Bitmap belonging to the main drawing surface, if `surface` was initialised.
   */
  public var bitmap(default, null):Bitmap;
  
  /**
Keyboard instance, if initialised with `ApplicationInit` `Keyboard`.
   */
  public var keyboard(default, null):Keyboard;
  
  /**
Mouse instance, if initialised with `ApplicationInit` `Mouse`.
   */
  public var mouse(default, null):Mouse;
  
  /**
Asset manager, if initialised with `ApplicationInit` `Assets`.
   */
  public var assetManager(default, null):AssetManager;
  
  /**
Console, if initialised with `ApplicationInit` `Console`.
   */
  public var console(default, null):Console;
  
  private var fps:Float;
  private var states:Array<State>;
  private var statesMap:Map<String, State>;
  
  /**
Constructs the application and initialises specific systems based on the
`ApplicationInit` values provided.
   */
  public function new(inits:Array<ApplicationInit>){
    fps = -1;
    states = [];
    statesMap = new Map<String, State>();
    for (init in inits){
      switch (init){
        case Assets(assets):
        assetManager = new AssetManager(assets);
        if (console != null){
          assetManager.attachConsole(console);
        }
        
        case Console:
        console = new Console();
        
        case ConsoleRemote(host, port):
        this.console.attachRemote(host, port);
        
        case Framerate(fps):
        this.fps = fps;
        Platform.source.listen("tick", handleTick);
        
        case Keyboard:
        keyboard = Platform.initKeyboard();
        if (console != null){
          console.attachKeyboard(keyboard);
        }
        Platform.source.listen("kdown", handleKeyDown);
        Platform.source.listen("kup",   handleKeyUp  );
        
        case Mouse:
        mouse = Platform.initMouse();
        Platform.source.listen("mclick", handleMouseClick);
        Platform.source.listen("mdown",  handleMouseDown );
        Platform.source.listen("mmove",  handleMouseMove );
        Platform.source.listen("mup",    handleMouseUp   );
        
        case Surface(width, height, scale):
        surface = Platform.initSurface(width, height, scale);
        bitmap = surface.bitmap;
        if (console != null){
          console.attachSurface(surface);
        }
        
        case Window(title, width, height):
        Platform.initWindow(title, width, height);
      }
    }
    if (console != null){
      console.applicationInits = inits;
    }
  }
  
  private function handleTick(event:ETick):Bool {
    if (console != null){
      if (console.applicationTick){
        currentState.tick();
      }
      console.tick();
    } else {
      currentState.tick();
    }
    return true;
  }
  
  private function handleKeyDown(event:EKDown):Bool {
    currentState.keyDown(event.key);
    return true;
  }
  
  private function handleKeyUp(event:EKUp):Bool {
    currentState.keyUp(event.key);
    return true;
  }
  
  private function handleMouseClick(event:EMClick):Bool {
    currentState.mouseClick(event.x, event.y);
    return true;
  }
  
  private function handleMouseDown(event:EMDown):Bool {
    currentState.mouseDown(event.x, event.y);
    return true;
  }
  
  private function handleMouseMove(event:EMMove):Bool {
    currentState.mouseMove(event.x, event.y);
    return true;
  }
  
  private function handleMouseUp(event:EMUp):Bool {
    currentState.mouseUp(event.x, event.y);
    return true;
  }
  
  /**
Adds the given state to this application and associates its `id` with it.

If this is the first call to `addState()`, the state given will also become
the initial state, which is entered when the application starts.
   */
  public function addState(state:State):Void {
    if (states.length == 0){
      initialState = state;
    }
    states.push(state);
    statesMap.set(state.id, state);
  }
  
  /**
Changes the current state to the one given. Calls the previous state's `from`
method before, and calls the give state's `to` method after.
   */
  public function applyState(state:State):Void {
    currentState.from();
    currentState = state;
    currentState.to();
  }
  
  public function reset():Void {
    currentState = initialState;
  }
  
  public function getMemory():Application {
    return this;
  }
  
  /**
Returns the current state - use `Application.currentState` instead.
   */
  public function getState():State {
    return currentState;
  }
  
  /**
@return State whose `id` property is equals to the one given or `null`.
   */
  public function getStateById(id:String):State {
    return statesMap.get(id);
  }
  
  /**
Enters the main loop of the application.

If `sk.thenet.app.ApplicationInit.Framerate` has been passed to the constructor,
this function will never return on some Platforms.
   */
  public function mainLoop():Void {
    if (states.length < 1){
      throw "no states specified";
    }
    currentState = initialState;
    currentState.to();
    if (fps > 0){
      Platform.initFramerate(fps);
    }
  }
}
