package sk.thenet.plat.js.common.audio;

#if js

import js.html.Audio;
import sk.thenet.audio.Sound.LoopMode;

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
  private var channels:Array<Audio>;
  private var pool:Array<Audio>;
  
  private function new(sound:Audio) {
    this.sound = sound;
    channels = [];
    pool = [];
  }
  
  public function play(?mode:LoopMode, ?volume:Float = 1):Void {
    var channel:Audio = null;
    if (pool.length > 0) {
      channel = pool.shift();
    } else {
      channel = (cast (sound.cloneNode()):Audio);
    }
    channel.volume = volume;
    channel.onended = (switch (mode) {
        case Forever:
        function() {
          channel.currentTime = 0;
          channel.play();
        };
        
        case Loop(amount):
        var counter = amount;
        function() {
          counter--;
          if (counter > 0) {
            channel.currentTime = 0;
            channel.play();
          } else {
            channels.remove(channel);
            pool.push(channel);
          }
        };
        
        case _:
        null;
      });
    channel.play();
    channels.push(channel);
  }
  
  public function stop():Void {
    for (channel in channels) {
      channel.onended = null;
      channel.pause();
      channel.currentTime = 0;
      pool.push(channel);
    }
    channels = [];
  }
}

#end
