package sk.thenet.plat.js.common.net.ws;

#if js

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import js.html.Blob;
import js.html.FileReader;
import js.html.WebSocket as NativeWebsocket;
import sk.thenet.event.EData;
import sk.thenet.event.Event;
import sk.thenet.event.Source;
import sk.thenet.plat.Platform;

/**
##JavaScript - Websocket##
 */
class Websocket extends Source implements sk.thenet.net.ws.IWebsocket {
  public var connected(default, null):Bool = false;
  public var handshake(default, null):Bool = false;
  
  private var socket:NativeWebsocket;
  private var sendQueue:Array<Bytes>;
  
  public function new(){
    super();
    sendQueue = [];
  }
  
  public function connect(host:String, url:String, port:Int):Void {
    if (host.indexOf("ws://") == -1 && host.indexOf("wss://") == -1){
      host = "ws://" + host;
    }
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
    for (s in sendQueue){
      send(s);
    }
  }
  
  private function handleData(ev:js.html.MessageEvent):Void {
    if (Std.is(ev.data, Blob)){
      var fileReader = new FileReader();
      fileReader.onload = function(){
        var data = Bytes.ofData(fileReader.result);
        fireEvent(new EData(this, data));
      };
      fileReader.readAsArrayBuffer(ev.data);
    } else {
      var data = Bytes.ofString(ev.data);
      fireEvent(new EData(this, data));
    }
  }
  
  public inline function send(data:Bytes, ?binary:Bool = false):Void {
    if (!connected){
      sendQueue.push(data);
      return;
    }
    socket.send(data.toString());
  }
  
  public function close():Void {
    connected = false;
    handshake = false;
    socket.close();
  }
}

#end
