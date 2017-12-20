package sk.thenet.plat.flash.audio;

#if flash

import sk.thenet.audio.Sound.LoopMode;
import flash.events.Event;
import flash.media.Sound as NativeSound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

using sk.thenet.FM;

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
  private var channels:Array<Channel>;
  
  private function new(sound:NativeSound) {
    this.sound = sound;
    channels = [];
  }
  
  public function play(?mode:LoopMode, ?volume:Float = 1.0):sk.thenet.audio.IChannel {
    var channel = new Channel((switch (mode) {
        case Forever: sound.play(0, 1000000);
        case Loop(amount): sound.play(0, amount);
        case _: sound.play();
      }), this);
    if (volume != 1.0) {
      channel.setVolume(volume);
    }
    channels.push(channel);
    return channel;
  }
  
  public function stop():Void {
    for (channel in channels) {
      channel.stop();
    }
  }
}

@:allow(sk.thenet.plat.flash)
class Channel implements sk.thenet.audio.IChannel {
  public var playing:Bool = true;
  
  private var native:SoundChannel;
  private var sound:Sound;
  
  private var volume:Float = 1.0;
  private var pan:Float = 0.0;
  
  private function new(native:SoundChannel, sound:Sound) {
    this.native = native;
    this.sound = sound;
    native.addEventListener(Event.SOUND_COMPLETE, function(event:Event) {
        stop();
      }, false, 0, true);
  }
  
  public function setVolume(volume:Float):Void {
    this.volume = volume.clampF(0, 1);
    native.soundTransform = new SoundTransform(this.volume, pan);
  }
  
  public function setPan(pan:Float):Void {
    this.pan = pan.clampF(-1, 1);
    native.soundTransform = new SoundTransform(volume, this.pan);
  }
  
  public function stop():Void {
    if (playing) {
      playing = false;
      native.stop();
      sound.channels.remove(this);
    }
  }
}

#end
