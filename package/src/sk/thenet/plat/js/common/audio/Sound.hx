package sk.thenet.plat.js.common.audio;

#if js

import js.html.Audio;
import sk.thenet.audio.Sound.LoopMode;

using sk.thenet.FM;

/**
JavaScript implementation of `sk.thenet.audio.ISound`.

@see `sk.thenet.audio.ISound`
 */
@:allow(sk.thenet.plat.js)
class Sound implements sk.thenet.audio.ISound {
  public var playing(get, null):Bool;
  
  private inline function get_playing():Bool {
    return channels.length > 0;
  }
  
  private var sound:Audio;
  private var channels:Array<Channel>;
  private var pool:Array<Audio>;
  
  private function new(sound:Audio) {
    this.sound = sound;
    channels = [];
    pool = [];
  }
  
  public function play(?mode:LoopMode, ?volume:Float = 1):sk.thenet.audio.IChannel {
    var native:Audio = null;
    if (pool.length > 0) {
      native = pool.shift();
    } else {
      native = (cast (sound.cloneNode()):Audio);
    }
    var channel = new Channel(native, this);
    channel.setVolume(volume);
    native.onended = (switch (mode) {
        case Forever:
        function() {
          native.currentTime = 0;
          native.play();
        };
        
        case Loop(amount):
        var counter = amount;
        function() {
          counter--;
          if (counter > 0) {
            native.currentTime = 0;
            native.play();
          } else {
            channel.stop();
          }
        };
        
        case _:
        function() {
          channel.stop();
        };
      });
    native.play();
    channels.push(channel);
    return channel;
  }
  
  public function stop():Void {
    for (channel in channels) {
      channel.stop();
    }
    channels = [];
  }
}

@:allow(sk.thenet.plat.js)
class Channel implements sk.thenet.audio.IChannel {
  public var playing:Bool = true;
  
  private var native:Audio;
  private var sound:Sound;
  
  private var volume:Float = 1.0;
  private var pan:Float = 0.0;
  
  private function new(native:Audio, sound:Sound) {
    this.native = native;
    this.sound = sound;
  }
  
  public function setVolume(volume:Float):Void {
    this.volume = volume.clampF(0, 1);
    native.volume = volume;
  }
  
  public function setPan(pan:Float):Void {
    this.pan = pan.clampF(-1, 1);
    //native.soundTransform = new SoundTransform(volume, this.pan);
  }
  
  public function stop():Void {
    if (playing) {
      playing = false;
      native.onended = null;
      native.pause();
      native.currentTime = 0;
      sound.pool.push(native);
    }
  }
}

#end
