package sk.thenet.plat.neko;

#if neko

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import sys.net.Host;
import sys.net.Socket as NativeSocket;
import neko.vm.Mutex;
import neko.vm.Thread;
import sk.thenet.event.EData;
import sk.thenet.event.Event;
import sk.thenet.event.Source;

@:allow(sk.thenet.plat.neko)
class Socket extends Source implements sk.thenet.net.ISocket {
  private inline static var READ_BUFFER:Int = 1 << 16;
  
  public var connected(default, null):Bool = false;
  
  private var socket:NativeSocket;
  private var sendMutex:Mutex;
  private var sendQueue:Array<Bytes>;
  private var socketArr:Array<NativeSocket>;
  public var plugged:Bool;
  
  private function new(?socket:NativeSocket) {
    super();
    plugged = true;
    if (socket == null) {
      this.socket = new NativeSocket();
    } else {
      this.socket = socket;
      socket.setBlocking(false);
      connected = true;
    }
    socketArr = [socket];
    sendMutex = new Mutex();
    sendQueue = [];
  }
  
  public function connect(host:String, port:Int):Void {
    socket.connect(new Host(host), port); // try-catch here
    socket.setBlocking(false);
    connected = true;
    plugged = false;
    fireEvent(new Event(this, "connect"));
    Thread.create(handleThread);
    //handleThread();
  }
  
  private function handleThread():Void {
    var readBuffer = Bytes.alloc(READ_BUFFER);
    while (connected) {
      /*if (plugged) {
        Sys.sleep(.1);
        continue;
      }*/
      /*
      var res = NativeSocket.select(socketArr, socketArr, socketArr, .05);
      if (res.read.length > 0) {*/
        try {
          var read = socket.input.readBytes(readBuffer, 0, READ_BUFFER);
          if (read > 0) {
            //trace("socket got data: " + readBuffer.toString());
            fireEvent(new EData(this, readBuffer.sub(0, read)));
            /*
            last_remote_activity = Sys.time();
            */
          }
        } catch (e:haxe.io.Error) {
        } catch (e:haxe.io.Eof) {
          //handleEof();
          connected = false;
        }
      //}
      //if (res.write.length > 0) {
        sendMutex.acquire();
        var data = (sendQueue.length > 0 ? sendQueue.shift() : null);
        sendMutex.release();
        if (data != null) {
          //trace("sending", data.toString());
          socket.setBlocking(true);
          socket.output.writeFullBytes(data, 0, data.length);
          socket.setBlocking(false);
        }
      //}
      Sys.sleep(.05);
    }
  }
  
  private var spawn:Socket->Void;
  
  public function serve(host:String, port:Int, spawn:Socket->Void):Void {
    this.spawn = spawn;
    socket.bind(new Host(host), port);
    socket.listen(10);
    socket.setBlocking(false);
    connected = true;
    plugged = false;
    fireEvent(new Event(this, "connect"));
    Thread.create(handleServe);
    //handleServe();
  }
  
  private function handleServe():Void {
    while (connected) {
      if (plugged) {
        Sys.sleep(.1);
        continue;
      }
      try {
        var child = new Socket(socket.accept());
        spawn(child);
        child.plugged = false;
        Thread.create(child.handleThread);
        //child.handleThread();
      } catch (e:Dynamic) {
      }/* catch (e:haxe.io.Error) {
      } catch (e:haxe.io.Eof) {
        //handleEof();
        connected = false;
      }*/
      Sys.sleep(.05);
    }
  }
  
  public function send(data:Bytes):Void {
    sendMutex.acquire();
    sendQueue.push(data);
    sendMutex.release();
  }
  
  public function close():Void {
    connected = false;
    socket.close();
  }
}

#end
