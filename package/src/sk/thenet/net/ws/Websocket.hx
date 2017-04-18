package sk.thenet.net.ws;

import haxe.crypto.Base64;
import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import sk.thenet.event.EData;
import sk.thenet.event.Event;
import sk.thenet.event.Source;
import sk.thenet.net.http.Method as HttpMethod;
import sk.thenet.net.http.Tools as HttpTools;
import sk.thenet.plat.Platform;
import sk.thenet.net.Socket;

using sk.thenet.format.BytesTools;

/**
##Websocket##

A pure Haxe implementation of a Websocket class capable of connecting to remote
Websocket servers as well as creating a Websocket server.

The implementation depends on `sk.thenet.net.Socket`, which is
platform-dependent. Some platforms might not support socket servers.
 */
class Websocket extends Source {
  public var connected(default, null):Bool = false;
  public var handshake(default, null):Bool = false;
  
  public var host:String;
  public var url:String;
  public var port:Int;
  public var origin:String;
  public var protocols:Array<String>;
  public var additionalHeaders:Map<String, String>;
  
  private var socket:Socket;
  private var sendQueue:Array<WebsocketFrame>;
  private var recvQueue:Array<WebsocketFrame>;
  private var recvBuffer:Bytes;
  private var recvUsed:Int;
  private var handshakeEnd:Int;
  private var serverMode:Bool = false;
  
  public function new(){
    super();
  }
  
  private function spawn(socket:Socket){
    sendQueue = [];
    recvQueue = [];
    recvBuffer = Bytes.alloc(256);
    recvUsed = 0;
    handshakeEnd = 0;
    connected = true;
    serverMode = true;
    
    this.socket = socket;
    socket.listen("data", handleData);
    socket.send(Bytes.ofString("HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\n\r\n"));
  }
  
  public function connect(host:String, url:String, port:Int):Void {
    this.host = host;
    this.url  = url;
    this.port = port;
    sendQueue = [];
    recvQueue = [];
    recvBuffer = Bytes.alloc(256);
    recvUsed = 0;
    handshakeEnd = 0;
    
    socket = Platform.createSocket();
    socket.listen("connect", handleConnect);
    socket.listen("data", handleData);
    socket.connect(host, port);
  }
  
  public function serve(host:String, url:String, port:Int, spawn:Websocket->Void):Void {
    socket = Platform.createSocket();
    socket.serve(host, port, function(socket:Socket){
        var ws = new Websocket();
        ws.spawn(socket);
        spawn(ws);
        //socket.plugged = false;
      });
  }
  
  private function handleConnect(ev:Event):Bool {
    fireEvent(new Event(this, "connect"));
    connected = true;
    
    var headers = [
        "Host" => host,
        "Upgrade" => "websocket",
        "Connection" => "Upgrade",
        "Sec-WebSocket-Version" => "13",
        "Sec-WebSocket-Key" => Base64.encode(FM.prng.nextBytes(16))
      ];
    
    if (origin != null){
      headers.set("Origin", origin);
    }
    if (protocols != null){
      headers.set("Sec-WebSocket-Protocol", protocols.join(", "));
    }
    if (additionalHeaders != null){
      for (key in additionalHeaders.keys()){
        headers.set(key, additionalHeaders.get(key));
      }
    }
    
    socket.send(HttpTools.createRequest(url, HttpMethod.GET, headers));
    
    return true;
  }
  
  private function handleRecv(data:Bytes):Void {
    if (!connected || data.length == 0){
      return;
    }
    if (data.length + recvUsed > recvBuffer.length){
      var tmp = recvBuffer;
      var nlen = tmp.length << 1;
      while (nlen < data.length + recvUsed){
        nlen <<= 1;
      }
      recvBuffer = Bytes.alloc(nlen);
      recvBuffer.blit(0, tmp, 0, tmp.length);
    }
    recvBuffer.blit(recvUsed, data, 0, data.length);
    recvUsed += data.length;
  }
  
  private function discardRecv(length:Int):Void {
    recvBuffer.blit(0, recvBuffer, length, recvUsed - length);
    recvUsed -= length;
  }
  
  private function handleFrame(frame:WebsocketFrame):Void {
    switch (frame.type){
      case Close:
      // close?
      
      case Ping:
      // pong
      
      case Pong:
      // ping
      
      case _:
      if (frame.fin){
        var fullPayload = new BytesBuffer();
        for (f in recvQueue){
          fullPayload.add(f.data);
        }
        recvQueue = [];
        fullPayload.add(frame.data);
        fireEvent(new EData(this, fullPayload.getBytes()));
      } else {
        recvQueue.push(frame);
      }
    }
  }
  
  private function handleFrames():Void {
    while (true){
      if (recvUsed < 2){
        return;
      }
      var b1 = recvBuffer.get(1);
      
      var masked = (b1 & 0x80 != 0);
      var length = (b1 & 0x7F);
      
      var minLen = (switch (length){
          case 127: 10;
          case 126: 4;
          case _:   2;
        });
      var maskAt = minLen;
      minLen += (masked ? 4 : 0);
      
      if (recvUsed < minLen){
        return;
      }
      
      var b0 = recvBuffer.get(0);
      
      var fin      = (b0 & 0x80 != 0);
      var reserved = ((b0 & 0x70) >> 4);
      var opcode   = (b0 & 0x8);
      
      length = (switch (length){
          case 127:
          var lengthHigh:UInt = recvBuffer.readLEInt32(2);
          if (lengthHigh != 0){
            throw "frame too long";
          }
          recvBuffer.readLEInt32(6);
          
          case 126:
          recvBuffer.readLEInt16(2);
          
          case _:
          length;
        });
      
      var fullLen = minLen + length;
      
      if (recvUsed < fullLen){
        return;
      }
      
      var payload = Bytes.alloc(length);
      payload.blit(0, recvBuffer, minLen, length);
      if (masked){
        var mask = recvBuffer.sub(maskAt, 4);
        maskData(payload, mask);
      }
      discardRecv(fullLen);
      
      handleFrame(new WebsocketFrame((cast opcode:Int), payload, fin));
      
      if (recvUsed >= 2){
        continue;
      }
      break;
    }
  }
  
  private function handleData(ev:EData):Bool {
    handleRecv(ev.data);
    if (!handshake){
      for (i in handshakeEnd...recvUsed){
        if (i < 3) continue;
        if (recvBuffer.readLEInt32(i - 3) == 0x0D0A0D0A){
          handshake = true;
          discardRecv(i + 1);
          for (f in sendQueue){
            sendFrame(f);
          }
          sendQueue = [];
          break;
        }
      }
      if (!handshake){
        handshakeEnd = recvUsed;
      }
    }
    if (handshake){
      handleFrames();
    }
    return true;
  }
  
  private function maskData(data:Bytes, mask:Bytes):Void {
    var maskInt = mask.getInt32(0);
    var maskBytes = new Vector<Int>(4);
    for (i in 0...4){
      maskBytes[i] = mask.get(i);
    }
    var fl4 = ((data.length >> 2) << 2);
    var i = 0;
    while (i < fl4){
      data.setInt32(i, data.getInt32(i) ^ maskInt);
      i += 4;
    }
    while (i < data.length){
      data.set(i, data.get(i) ^ maskBytes[i % 4]);
      i++;
    }
  }
  
  private function sendFrame(frame:WebsocketFrame):Void {
    if (!handshake){
      sendQueue.push(frame);
      return;
    }
    
    var masked = !serverMode;
    var length = frame.data.length;
    
    var sendBuffer = Bytes.alloc(
          2
        + (masked ? 4 : 0)
        + (length > 125 ? 2 : 0)
        + (length > 65536 ? 6 : 0)
        +  length
      );
    sendBuffer.set(0, 0x80 | (cast (frame.type):Int));
    
    var maskAt = (if (length > 65536){
        sendBuffer.set(1, (masked ? 0xFF : 0x7F));
        sendBuffer.setInt32(2, 0);
        sendBuffer.setInt32(6, length);
        10;
      } else if (length > 125){
        sendBuffer.set(1, (masked ? 0xFE : 0x7E));
        sendBuffer.set(2, length >> 8);
        sendBuffer.set(3, length & 0xFF);
        4;
      } else {
        sendBuffer.set(1, (masked ? 0x80 : 0) | length);
        2;
      });
    
    if (masked){
      var mask = FM.prng.nextBytes(4);
      sendBuffer.blit(maskAt, mask, 0, 4);
      maskData(frame.data, mask);
    }
    sendBuffer.blit(maskAt + (masked ? 4 : 0), frame.data, 0, length);
    socket.send(sendBuffer);
  }
  
  public inline function send(data:Bytes):Void {
    sendFrame(new WebsocketFrame(WebsocketFrameType.Text, data, true));
  }
  
  public function close():Void {
    connected = false;
    handshake = false;
  }
}

private class WebsocketFrame {
  public var type(default, null):WebsocketFrameType;
  public var data(default, null):Bytes;
  public var fin (default, null):Bool;
  
  public function new(type:WebsocketFrameType, data:Bytes, fin:Bool){
    this.type = type;
    this.data = data;
    this.fin  = fin;
  }
}

@:enum
private abstract WebsocketFrameType(Int) from Int to Int {
  var None = 0;
  var Text = 1;
  var Binary = 2;
  var Other3 = 3;
  var Other4 = 4;
  var Other5 = 5;
  var Other6 = 6;
  var Other7 = 7;
  var Close = 8;
  var Ping = 9;
  var Pong = 10;
  var Control3 = 11;
  var Control4 = 12;
  var Control5 = 13;
  var Control6 = 14;
  var Control7 = 15;
}
