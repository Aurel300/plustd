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

####Using the Application model####

The classes in the `sk.thenet.app` package are for the most part convenience
classes for easy creating of cross-platform interactive applications. To use
this model as intended:

 - Make your `Main` extend `Application`.
 - Use this as the `main` method:
```haxe
    public static function main():Void Platform.boot(function() new Main());
```
 - In the constructor of `Main`, call `super()` with an array of
    `ApplicationInit`s.
 - Also add any `State`s with the `addState()` (the first state passed is the
    initial state), and if needed, the preloader state with
    `preloader = new SubclassOfPreloader(this);`
 - Finally, call `mainLoop()`.

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
  
  /**
The preloader state.
   */
  public var preloader(default, null):Preloader;
  
  private var fps:Float;
  private var states:Array<State>;
  private var statesMap:Map<String, State>;
  
  /**
Constructs the application and initialises specific systems based on the
`ApplicationInit` values provided.

@see `ApplicationInit`
   */
  public function new(inits:Array<ApplicationInit>){
    fps = -1;
    var fpsInit:Bool = false;
    states = [];
    statesMap = new Map<String, State>();
    for (init in inits){
      switch (init){
        case Assets(assets) if (assetManager == null):
        assetManager = new AssetManager(assets);
        
        case Console if (console == null):
        console = new Console();
        
        case ConsoleRemote(host, port):
        console.attachRemote(host, port);
        
        case Framerate(fps) if (!fpsInit):
        fpsInit = true;
        this.fps = fps;
        Platform.source.listen("tick", handleTick);
        
        case Keyboard if (keyboard == null):
        keyboard = Platform.initKeyboard();
        Platform.source.listen("kdown", handleKeyDown);
        Platform.source.listen("kup",   handleKeyUp  );
        
        case Mouse if (mouse == null):
        mouse = Platform.initMouse();
        Platform.source.listen("mclick", handleMouseClick);
        Platform.source.listen("mdown",  handleMouseDown );
        Platform.source.listen("mmove",  handleMouseMove );
        Platform.source.listen("mup",    handleMouseUp   );
        
        case Surface(width, height, scale) if (surface == null):
        surface = Platform.initSurface(width, height, scale);
        bitmap = surface.bitmap;
        
        case Window(title, width, height):
        Platform.initWindow(title, width, height);
        
        case _:
        throw "duplicate ApplicationInits";
      }
    }
    if (console != null){
      if (assetManager != null){
        console.assetManager = assetManager;
        assetManager.attachConsole(console);
      }
      console.keyboard = keyboard;
      console.surface = surface;
      console.applicationInits = inits;
    }
  }
  
  private function handleTick(event:ETick):Bool {
    if (assetManager != null && preloader != null && currentState == preloader){
      preloader.progress(assetManager.assets);
      /*
      if (assetManager.assetsLoaded){
        applyState(initialState);
      } else {
        preloader.progress(assetManager.assets);
      }*/
    }
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
the initial state, which is entered when the application starts. (After the
preloading is done.)
   */
  public function addState(state:State):Void {
    if (states.length == 0){
      initialState = state;
    } else if (statesMap.exists(state.id)){
      throw "duplicate state";
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
  
  /**
Resets the application to the initial state.
   */
  public function reset():Void {
    currentState = initialState;
  }
  
  @:dox(hide)
  public function getMemory():Application {
    return this;
  }
  
  /**
@return Current state - use `Application.currentState` instead.
   */
  public function getState():State {
    return currentState;
  }
  
  /**
@return State whose `id` property equals to the one given or `null`.
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
    if (assetManager != null && preloader != null){
      currentState = preloader;
    } else {
      currentState = initialState;
    }
    currentState.to();
    if (fps > 0){
      Platform.initFramerate(fps);
    }
  }
}
