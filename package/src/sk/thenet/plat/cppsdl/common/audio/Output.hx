package sk.thenet.plat.cppsdl.common.audio;

#if cpp

import haxe.ds.Vector;
import  sk.thenet.plat.cppsdl.common.SDL.MixChunkPointer;

/**
C++ / SDL implementation of `sk.thenet.audio.IOutput`.

@see `sk.thenet.audio.IOutput`
 */
@:allow(sk.thenet.plat.cppsdl)
@:build(sk.thenet.plat.cppsdl.common.SDLMacro.slave("../"))
class Output implements sk.thenet.audio.IOutput {
  public var playing (default, null):Bool = false;
  public var channels(default, null):Int;
  public var samples (default, null):Int;
  
  private var sound:Sound;
  private var chunk:MixChunkPointer;
  private var buffer:Vector<Float>;
  private var bufferInt:Vector<cpp.UInt8>;
  
  private function new(channels:Int = 2, samples:Int = 8192){
    this.channels = channels;
    this.samples = samples;
    
    untyped __cpp__("Mix_Chunk chunk");
    chunk = untyped __cpp__("chunk");
    
    buffer = new Vector<Float>(channels * samples);
    bufferInt = new Vector<cpp.UInt8>(channels * samples);
    
    chunk.allocated = 0;
    chunk.abuf = cpp.Pointer.ofArray(bufferInt.toData());
    chunk.alen = samples * channels;
    chunk.volume = 128;
    
    sound = new Sound(chunk);
    /*
    buffer = new Vector<Float>(channelsSamples);
    for (i in 0...channelsSamples){
      buffer[i] = 0;
    }
    */
  }
  
  public function play():Void {
    
  }
  
  public function stop():Void {
    
  }
  
  private function handleSample():Void {
    
  }
  
  public dynamic function sample(offset:Float, buffer:Vector<Float>):Void {}
}

#end
