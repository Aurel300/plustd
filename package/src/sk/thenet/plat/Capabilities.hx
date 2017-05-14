package sk.thenet.plat;

/**
##Platform capabilities##

This class summarises the capabilities of a platform. A number of `Bool`
properties are available. When using functionality that is not available on
all platforms the needed capability should be checked first, in order to avoid
throwing an exception:

```haxe
    if (Platform.websocket){
      var sock = Platform.createWebsocket();
      // code using sock
    } else {
      // secondary code
    }
```

Instances of this class are available in any platform. To get the capabilities
of the current platform, use `Platform.capabilities`.
 */
class Capabilities {
  /**
Keyboard capable platforms support keyboard events.
   */
  public var keyboard(default, null):Bool = false;
  
  /**
Mouse capable platforms support mouse events.
   */
  public var mouse(default, null):Bool = false;
  
  /**
Real-time capable platforms support a constant framerate and can fire regular
tick events.
   */
  public var realtime(default, null):Bool = false;
  
  /**
Socket capable platforms can create a socket object which can be used to connect
via TCP to a remote server on a given port.
   */
  public var socket(default, null):Bool = false;
  
  /**
Socket server capable platforms can create a socket object and use it to listen
for incoming TCP connections.
   */
  public var socketServer(default, null):Bool = false;
  
  /**
Surface capable platforms can create a bitmap surface which the application can
use to display information, components, etc. to the user.
   */
  public var surface(default, null):Bool = false;
  
  /**
Websocket capable platforms can connect via the websocket protocol to a remote
server. This is separate from `isSocketCapable`, because JavaScript in the
browser can connect to Websocket servers, but not arbitrary socket servers.
   */
  public var websocket(default, null):Bool = false;
  
  /**
Window capable platforms can create a main window with a title and display it
in the window system of the underlying OS.
   */
  public var window(default, null):Bool = false;
  
  public function new(?cs:Array<Capability>){
    if (cs != null){
      for (c in cs){
        switch (c){
          case Keyboard:     keyboard     = true;
          case Mouse:        mouse        = true;
          case Realtime:     realtime     = true;
          case Socket:       socket       = true;
          case SocketServer: socketServer = true;
          case Surface:      surface      = true;
          case Websocket:    websocket    = true;
          case Window:       window       = true;
        }
      }
    }
  }
}

enum Capability {
  Keyboard;
  Mouse;
  Realtime;
  Socket;
  SocketServer;
  Surface;
  Websocket;
  Window;
}
