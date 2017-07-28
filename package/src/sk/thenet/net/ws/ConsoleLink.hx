package sk.thenet.net.ws;

import haxe.io.Bytes;
import sk.thenet.event.EData;
import sk.thenet.event.EFile;
import sk.thenet.event.Source;
import sk.thenet.plat.Platform;

using sk.thenet.format.BytesTools;

/**
Used by `sk.thenet.app.Console`.
 */
class ConsoleLink extends Source {
  private var socket:Websocket;
  
  public function new() {
    super();
    socket = Platform.createWebsocket();
    forward("connect", socket);
    socket.listen("data", handleData);
  }
  
  private function handleData(event:EData):Bool {
    var data = event.data;
    if (data.length < 1) {
      return false;
    }
    switch (data.get(0)) {
      case 0x01:
      fireEvent(new EData(this, data.sub(1, data.length - 1)));
      case 0x02:
      var nameLen = data.get(1);
      //var fileLen = data.readLEInt32(2);
      var name    = data.sub(2, nameLen).toString();
      var file    = data.sub(2 + nameLen, data.length - 2 - nameLen); //, fileLen);
      fireEvent(new EFile(this, name, function() return file));
    }
    return true;
  }
  
  public function connect(host:String, port:Int):Void {
    socket.connect(host, "/", port);
  }
  
  public function monitor(file:String):Void {
    socket.send(Bytes.ofString("\x02" + file));
  }
  
  public function sendFile(data:Bytes):Void {
    var o = Bytes.alloc(data.length + 1);
    o.set(0, 0x03);
    o.blit(1, data, 0, data.length);
    socket.send(o, true);
  }
}
