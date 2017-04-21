package sk.thenet.net.ws;

import haxe.io.Bytes;
import sk.thenet.event.ISource;

/**
##Websocket interface##
 */
interface IWebsocket extends ISource {
  /**
`true` iff the websocket is connected via TCP. On some platforms, this may
always have the same value as `handshake`.
   */
  public var connected(default, null):Bool;
  
  /**
`true` iff the websocket is connected and messages can be sent and received.
   */
  public var handshake(default, null):Bool;
  
  /**
Connects to a remote `host` at the given `url` and `port`.
   */
  public function connect(host:String, url:String, port:Int):Void;
  
  /**
Creates a Websocket server. The `spawn` function is called for any new client.
   */
  public function serve(
      host:String, url:String, port:Int, spawn:Websocket->Void
    ):Void;
  
  /**
Sends the given `data` over the Websocket connection. Uses a Text frame unless
`binary` is set to `true`.
   */
  public function send(data:Bytes, ?binary:Bool = false):Void;
  
  /**
Closes the connection.
   */
  public function close():Void;
}
