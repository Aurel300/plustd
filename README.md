**This library is in development**

I hope to release a usable version before Ludum Dare 38 both here and on Haxelib.

# plustd #

<img src="https://rawgit.com/Aurel300/plustd/master/assets/logo/logo.svg" alt="Logo" width="320">

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

Warning: this library is in development and any API might change dramatically between releases. Use at your own peril.

 1. Make sure your `haxe` and `haxelib` is set up.
 2. Run `haxelib git plustd https://github.com/Aurel300/plustd.git master package` to make `haxelib` use the git repo as a source for the library.
 3. Navigate to `plustd/samples/01-basic/`.
 4. Run `haxe make-swf.hxml` to test the Flash platform, or `haxe make-cpp.hxml` to test the C++ / SDL / Desktop platform (if you are on OS X). The output will be `demo.swf` and `demo/Main` respectively. The C++ build takes a long time when running for the first time.

### Overview ###

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
 - `.geom` - Geometric models
 - `.graph` - Graph algorithms
 - `.format` - Binary formats for various data types
 - `.fsm` - Finite state machine
 - `.geom` - Geometrical models
 - `.net` - Network protocols
 - `.plat` - Platform-dependent code
   - `.common` - Code shared by some (but not all) platforms
   - `.dummy` - Example platform
   - `.flash` - Flash code
   - `.js`
     - `.common`
     - `.canvas`
     - `.webgl` - (TODO)
 - `.stream` - Streaming for functional programming
 - `FM` - Fast Maths
 - `U` - Utilities