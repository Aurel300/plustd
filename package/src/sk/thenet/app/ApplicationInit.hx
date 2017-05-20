package sk.thenet.app;

/**
##Aplication - System initialisers##

Values of this enum should be passed to the constructor of `Application` to
initialise the relevant systems. The initialisation then uses the `init`
functions of `sk.thenet.plat.Platform` under the hood.
 */
enum ApplicationInit {
  /**
Initialise the `AssetManager` with the given array of `Asset`s. To ensure proper
preloading and asset binding / triggering, all required assets should be in the
array.
   */
  Assets(assets:Array<Asset>);
  
  /**
Initialise the debugging `Console`. This has additional effects if used with
`Surface`, `Framerate`, `Keyboard` - to ensure the console is interactive,
event listeners are added to the application.

@see `Console`
   */
  Console;
  
  /**
Initialise remote debugging and asset reloading for the console.
   */
  ConsoleRemote(host:String, port:Int);
  
  /**
Initialise a constant framerate of `fps` frames per second.
   */
  Framerate(fps:Float);
  
  /**
Initialise keyboard events.
   */
  Keyboard;
  
  /**
Initialise mouse events.
   */
  Mouse;
  
  /**
Initialise the main rendering surface. `scale` is the exponent of a power of
two - `0` results in a scaling factor of `2^0 = 1`, so no scaling is done. `1`
results in a scaling factor of `2^1 = 2`, so the width and height are doubled.
   */
  Surface(width:Int, height:Int, scale:Int);
  
  /**
Initialise the main window.
   */
  Window(title:String, width:Int, height:Int);
  
  /**
Initialise the given parameter only if available on the current platform. If the
feature is not available, fails silently.
   */
  Optional(init:ApplicationInit);
}
