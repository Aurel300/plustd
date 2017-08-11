package sk.thenet.plat.cppsdl.common.audio;

#if cpp

import sk.thenet.audio.Sound.LoopMode;
import sk.thenet.plat.cppsdl.common.SDL;
import sk.thenet.plat.cppsdl.common.SDL.MixChunkPointer;

/**
C++ / SDL implementation of `sk.thenet.audio.ISound`.

@see `sk.thenet.audio.ISound`
 */
@:allow(sk.thenet.plat.cppsdl)
@:build(sk.thenet.plat.cppsdl.common.SDLMacro.slave("../"))
class Sound implements sk.thenet.audio.ISound {
  private static var inited:Bool = false;
  private static var channelsMap:Map<Int, Sound>;
  
  public static function init():Void {
    if (!inited) {
      SDL.initSubSystem(SDL.INIT_AUDIO);
      SDL.Mixer.init(SDL.Mixer.INIT_MP3);
      SDL.Mixer.openAudio(44100, untyped __cpp__("AUDIO_F32"), 2, 1024);
      SDL.Mixer.channelFinished(cpp.Callable.fromStaticFunction(channelFinished));
      channelsMap = new Map<Int, Sound>();
      inited = true;
    }
  }
  
  private static function channelFinished(channel:Int):Void {
    var sound = channelsMap.get(channel);
    if (sound == null) {
      return;
    }
    sound.channels.remove(channel);
    channelsMap.remove(channel);
  }
  
  public var playing(get, null):Bool;
  
  private inline function get_playing():Bool {
    return channels.length > 0;
  }
  
  private var chunk:MixChunkPointer;
  private var channels:Array<Int>;
  
  private function new(chunk:MixChunkPointer) {
    this.chunk = chunk;
    channels = [];
  }
  
  public function play(?mode:LoopMode, ?volume:Float = 1):Void {
    var channel = SDL.Mixer.playChannel(-1, chunk, (switch (mode) {
        case Forever: -1;
        case Loop(amount): amount - 1;
        case _: 0;
      }));
    SDL.Mixer.volume(channel, Std.int(volume * SDL.Mixer.MAX_VOLUME));
    channels.push(channel);
    channelsMap.set(channel, this);
  }
  
  public function stop():Void {
    for (channel in channels) {
      channelsMap.remove(channel);
      SDL.Mixer.haltChannel(channel);
    }
    channels = [];
  }
}

#end
