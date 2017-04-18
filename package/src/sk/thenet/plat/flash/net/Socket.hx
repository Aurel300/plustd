package sk.thenet.plat.flash.net;

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import flash.events.Event as NativeEvent;
import flash.events.ProgressEvent as NativeProgressEvent;
import flash.net.Socket as NativeSocket;
import sk.thenet.event.EData;
import sk.thenet.event.Event;
import sk.thenet.event.Source;

@:allow(sk.thenet.plat.flash)
class Socket extends Source implements sk.thenet.net.ISocket {
  public var connected(default, null):Bool = false;
  
  private var socket:NativeSocket;
  
  private function new(){
    super();
    socket = new NativeSocket();
    socket.addEventListener(NativeEvent.CONNECT, handleConnect);
    socket.addEventListener(NativeProgressEvent.SOCKET_DATA, handleData);
  }
  
  private function handleConnect(ev:NativeEvent):Void {
    connected = true;
    fireEvent(new Event(this, "connect"));
  }
  
  private function handleData(ev:NativeProgressEvent):Void {
    var data = Bytes.alloc(socket.bytesAvailable);
    socket.readBytes(
         (cast (data.getData()):flash.utils.ByteArray)
        ,0, socket.bytesAvailable
      );
    fireEvent(new EData(this, data));
  }
  
  public function connect(host:String, port:Int):Void {
    socket.connect(host, port);
  }
  
  public function serve(host:String, port:Int, spawn:Socket->Void):Void {
    throw "unsupported operation";
  }
  
  public function send(data:Bytes):Void {
    socket.writeBytes((cast (data.getData()):flash.utils.ByteArray));
    socket.flush();
  }
  
  public function close():Void {
    socket.close();
  }
}
