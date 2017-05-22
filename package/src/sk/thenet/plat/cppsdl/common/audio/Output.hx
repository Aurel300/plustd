package sk.thenet.plat.cppsdl.common.audio;

#if cpp

import haxe.ds.Vector;
import  sk.thenet.plat.cppsdl.common.SDL.AudioSpecPointer;

/**
C++ / SDL implementation of `sk.thenet.audio.IOutput`.

@see `sk.thenet.audio.IOutput`
 */
@:allow(sk.thenet.plat.cppsdl)
@:build(sk.thenet.plat.cppsdl.common.SDLMacro.slave("../"))
class Output implements sk.thenet.audio.IOutput {
  private static var outputs:Map<Int, Output> = new Map<Int, Output>();
  private static var outputNum:Int = 0;
  
  public var playing (default, null):Bool = false;
  public var channels(default, null):Int;
  public var samples (default, null):Int;
  
  //private var sound:Sound;
  //private var chunk:MixChunkPointer;
  private var buffer:Vector<Float>;
  //private var spec:AudioSpecPointer;
  private var dev:Int;
  //private var bufferInt:Vector<cpp.UInt8>;
  
  private function new(channels:Int = 2, samples:Int = 8192){
    this.channels = channels;
    this.samples = samples;
    
    buffer = new Vector<Float>(channels * samples);
    
    untyped __cpp__("SDL_AudioSpec __spec, __obtained");
    untyped __cpp__("SDL_zero(__spec)");
    var spec:AudioSpecPointer = untyped __cpp__("__spec");
    spec.freq = 44100;
    spec.format = SDL.AUDIO_F32;
    spec.channels = channels;
    spec.samples = samples;
    /*
    var hsCall:cpp.Function<cpp.Pointer<cpp.Void>->cpp.Pointer<cpp.UInt8>->Int, cpp.abi.FastCall>
      = (cast cpp.Callable.fromStaticFunction(handleSample):cpp.Function<cpp.Pointer<cpp.Void>->cpp.Pointer<cpp.UInt8>->Int, cpp.abi.FastCall>);
    */
    /*
    spec.callback = untyped __cpp__(
         "(void (*)(void*, uint8_t*, int))({0})"
        ,cpp.Callable.fromStaticFunction(handleSample)
      );
    spec.userdata = untyped __cpp__("(void*)({0})", outputNum);
    outputs.set(outputNum, this);
    outputNum++;
    //spec.userdata = (cast cpp.Pointer.addressOf(this):cpp.Pointer<cpp.Void>);
    dev = SDL.openAudioDevice(
         untyped __cpp__("NULL")
        ,0
        ,spec
        ,untyped __cpp__("&__obtained")
        ,0
      );
    */
    //dev = untyped __cpp__("SDL_OpenAudioDevice(NULL, 0, &spec, &obtained, 0)");
    
    /*
    untyped __cpp__("Mix_Chunk* chunk = new Mix_Chunk()");
    chunk = untyped __cpp__("chunk");
    
    buffer = new Vector<Float>(channels * samples);
    //bufferInt = new Vector<cpp.UInt8>(channels * samples);
    for (i in 0...buffer.length){
      //bufferInt[i] = (cast FM.prng.nextMod(256):cpp.UInt8);
      buffer[i] = FM.prng.nextFloat(.1);
    }
    
    var ptr = cpp.Pointer.ofArray(buffer.toData());
    
    chunk.allocated = 0;
    untyped __cpp__("{0}->abuf = (uint8_t*)(&({1}->ptr))", chunk, ptr);
    //cpp.Pointer.ofArray(buffer.toData());
    chunk.alen = 5; //samples * channels;
    chunk.volume = 1;
    
    sound = new Sound(chunk);
    /*
    buffer = new Vector<Float>(channelsSamples);
    for (i in 0...channelsSamples){
      buffer[i] = 0;
    }
    */
  }
  
  public function play():Void {
    playing = true;
    //SDL.pauseAudioDevice(dev, 0);
  }
  
  public function stop():Void {
    playing = false;
    //SDL.pauseAudioDevice(dev, 1);
  }
  
  private static function handleSample(
    data:cpp.Star<cpp.Void>, stream:cpp.Star<cpp.UInt8>, len:Int
  ):Void {
    /*
    trace("got called");
    var destPointer:cpp.Pointer<cpp.Float32> = untyped __cpp__("(float_t*)({0})", stream);
    var dataPointer:cpp.Pointer<cpp.Void> = untyped __cpp__("(void*)({0})", data);
    var dataNum:Int = untyped __cpp__("(long int)({0})", dataPointer.ptr);
    var obj = outputs.get(dataNum);
    obj.sample(0, obj.buffer);
    cpp.Stdlib.memcpy(
         destPointer
        ,cpp.Pointer.ofArray(obj.buffer.toData())
        ,obj.samples * obj.channels * 4
      );
    */
  }
  
  public dynamic function sample(offset:Float, buffer:Vector<Float>):Void {}
}

#end
