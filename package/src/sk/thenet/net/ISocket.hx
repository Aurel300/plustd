package sk.thenet.net;

import haxe.io.Bytes;
import sk.thenet.event.ISource;

/**
##Socket interface##

This interface represents a network socket for TCP communications.

Implementations of this interface are platform-dependent. To maintain good
performance without having to actually cast classes to this interface, there
is a typedef available - `sk.thenet.plat.Socket` - which becomes an alias for
the current platform-dependent implementation of `ISocket` at compile time. To
actually create a `Socket`, use `sk.thenet.plat.Platform.createSocket()`.
 */
interface ISocket extends ISource {
  /**
Connects to a remote server `host` on `port`.
   */
  public function connect(host:String, port:Int):Void;
  
  /**
Starts listening for remote connections at `host` on `port`. Every time a client
connects, the `spawn` function is called with the child `ISocket`.
   */
  public function serve(host:String, port:Int, spawn:ISocket->Void):Void;
  
  /**
Sends the given `data` to the remote end.
   */
  public function send(data:Bytes):Void;
  
  /**
Closes the socket.
   */
  public function close():Void;
}
