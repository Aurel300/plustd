package sk.thenet.net.ws;

import haxe.io.Bytes;
import sk.thenet.event.ISource;

interface IWebsocket extends ISource {
  public var connected(default, null):Bool;
  
  public var handshake(default, null):Bool;
  
  public function connect(host:String, url:String, port:Int):Void;
  
  public function serve(
      host:String, url:String, port:Int, spawn:Websocket->Void
    ):Void;
  
  public function send(data:Bytes):Void;
  
  public function close():Void;
}
