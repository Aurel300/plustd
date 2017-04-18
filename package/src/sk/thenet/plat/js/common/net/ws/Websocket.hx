package sk.thenet.plat.js.common.net.ws;

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import js.html.WebSocket as NativeWebsocket;
import sk.thenet.event.EData;
import sk.thenet.event.Event;
import sk.thenet.event.Source;
import sk.thenet.plat.Platform;

using sk.thenet.format.BytesTools;

/**
##JavaScript - Websocket##
 */
class Websocket extends Source implements sk.thenet.net.ws.IWebsocket {
  public var connected(default, null):Bool = false;
  public var handshake(default, null):Bool = false;
  
  private var socket:NativeWebsocket;
  
  public function new(){
    super();
  }
  
  public function connect(host:String, url:String, port:Int):Void {
    socket = new NativeWebsocket(host + ":" + port + "/" + url);
    socket.onclose = handleClose;
    socket.onmessage = handleData;
    socket.onopen = handleConnect;
  }
  
  public function serve(
    host:String, url:String, port:Int, spawn:Websocket->Void
  ):Void {
    throw "unsupported operation";
  }
  
  private function handleClose(ev:js.html.CloseEvent):Void {
    connected = false;
    handshake = false;
  }
  
  private function handleConnect(ev:js.html.Event):Void {
    fireEvent(new Event(this, "connect"));
    connected = true;
    handshake = true;
  }
  
  private function handleData(ev:js.html.MessageEvent):Void {
    var data = Bytes.ofString(ev.data);
    fireEvent(new EData(this, data));
  }
  
  public inline function send(data:Bytes):Void {
    socket.send(data.toString());
  }
  
  public function close():Void {
    connected = false;
    handshake = false;
    socket.close();
  }
}
