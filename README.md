<img src="https://rawgit.com/Aurel300/plustd/master/assets/logo/logo.svg" alt="Logo" height="320" width="100%">

# plustd #

**This library is in development**

Plustd is a Haxe library in development, aimed at 2D game development, interactive apps, and more - performance-oriented while supporting many platforms.

Currently, it supports:

 - Flash
 - Javascript / Canvas
 - C++ / SDL / Desktop (OS X)
 - C++ / SDL / Phone (iOS is the current WIP)

In the near future, the goal is to add support for:

 - C++ / SDL / Desktop (Windows, Linux)
 - Javascript / WebGL

### Usage ###

**Warning: this library is in development and any API might change dramatically between releases. Use at your own peril.**

To use plustd in your haxe projects, include these lines at the beginning of your `make.hxml` (or within your command line arguments):

```haxe
    -D PLUSTD_TARGET=<specify target here>
    -D PLUSTD_OS=<specify OS here>
    -lib plustd
    <compilation target here>
```

Here are the values of `PLUSTD_TARGET`, `PLUSTD_OS` according to their intended compilation target and platform:

| Platform | `PLUSTD_TARGET` | `PLUSTD_OS` | Compilation target |
| --- | ---:| ---:| ---:|
| C++ / SDL / Desktop | `cppsdl.desktop` | `osx`, `win`, or `linux` | `-cpp` |
| C++ / SDL / Phone | `cppsdl.phone` | `ios` or `android` | `-cpp` |
| Flash | `flash` | (not used) | `-swf` |
| JavaScript / Canvas | `js.canvas` | (not used) | `-js` |
| JavaScript / WebGL | `js.webgl` | (not used) | `-js` |
| Neko VM  | `neko` | (not used) | `-neko` |

To use the features of plustd, make your class extend `sk.thenet.app.Application` and pass appropriate `sk.thenet.app.ApplicationInit` values to `super` in its constructor. Some platforms require additional setup beforehand, which is handled by `sk.thenet.plat.Platform.boot`. Here is an example class:

```haxe
    import sk.thenet.app.*;
    import sk.thenet.plat.Platform;
    
    class Main extends Application {
      public static function main() Platform.boot(function() new Main());
      
      public function new(){
        super([
             Framerate(60)
            ,Window("demo", 320, 240)
            ,Surface(160, 120, 1)
          ]);
        addState(new Test(this));
        mainLoop();
      }
    }
    
    class Test extends State {
      public function new(app:Main){
        super("test", app);
      }
      
      override public function tick(){
        app.bitmap.fill(0xFF000000 | FM.prng.nextMod(0xFFFFFF));
      }
    }
```

See the samples and API documentation for more details.

### Compiling samples ###

 1. Make sure your `haxe` and `haxelib` is set up.
 2. Run `haxelib git plustd https://github.com/Aurel300/plustd.git master package` to make `haxelib` use the git repo as a source for the library.
 3. Navigate to `plustd/git/samples/01-basic/`.
 4. Run `haxe make-swf.hxml` to test the Flash platform, or `haxe make-cpp.hxml` to test the C++ / SDL / Desktop platform (if you are on OS X). The output will be `demo.swf` and `demo/Main` respectively. The C++ build takes a long time when running for the first time.

### Package overview ###

 - `.app` - Application framework
   - `Application` base class for simple initialisation of event listeners and input / output devices
   - `AssetManager` with support for hot reloading (<s>local filesystem or</s> Websocket connection to plustd file watchdog)
   - `Embed` for cross-platform asset preloading
 - `.audio`
   - `Output` - Code-generated audio output
   - `Sound` - Sound sample
 - `.bmp` - Bitmap objects and manipulation
   - `Bitmap`
 - `.crypto` - Encodings and cryptography
 - `.ds` - Data structures
 - `.event` - Simple events + listeners
 - `.format` - Binary formats for various data types
 - `.fsm` - Finite state machine
 - `.geom` - Geometric models
 - `.graph` - Graph algorithms
 - `.net` - Network protocols
 - `.plat` - Platform-dependent code, generally not accessed directly when using this library
   - `.common` - Code shared by some (but not all) platforms
   - `.cppsdl`
     - `.common`
     - `.desktop` - C++ / SDL / Desktop platform
     - `.phone` - C++ / SDL / Phone platform
   - `.dummy` - Example platform
   - `.flash` - Flash platform
   - `.js`
     - `.common`
     - `.canvas` - JavaScript / Canvas platform
     - `.webgl` - JavaScript / WebGL platform (TODO)
 - `.stream` - Streaming for functional programming
 - `FM` - Fast Maths
 - `M` - Macro utilities
 - `U` - Utilities