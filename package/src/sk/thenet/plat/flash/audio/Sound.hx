package sk.thenet.plat.flash.audio;

#if flash

import sk.thenet.audio.Sound.LoopMode;
import flash.events.Event;
import flash.media.Sound as NativeSound;
import flash.media.SoundChannel;

/**
Flash implementation of `sk.thenet.audio.ISound`.

@see `sk.thenet.audio.ISound`
 */
@:allow(sk.thenet.plat.flash)
class Sound implements sk.thenet.audio.ISound {
  public var playing(get, null):Bool;
  
  private inline function get_playing():Bool {
    return channels.length > 0;
  }
  
  private var sound:NativeSound;
  private var channels:Array<SoundChannel>;
  
  private function new(sound:NativeSound) {
    this.sound = sound;
    channels = [];
  }
  
  public function play(?mode:LoopMode):Void {
    var channel = (switch (mode) {
        case Forever: sound.play(0, 1000000);
        case Loop(amount): sound.play(0, amount);
        case _: sound.play();
      });
    channel.addEventListener(Event.SOUND_COMPLETE, function(event:Event) {
        channels.remove(channel);
      }, false, 0, true);
    channels.push(channel);
  }
  
  public function stop():Void {
    for (channel in channels) {
      channel.stop();
    }
    channels = [];
  }
}

#end
