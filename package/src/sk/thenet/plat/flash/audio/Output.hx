package sk.thenet.plat.flash.audio;

#if flash

import haxe.ds.Vector;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.events.SampleDataEvent;

/**
Flash implementation of `sk.thenet.audio.IOutput`.

@see `sk.thenet.audio.IOutput`
 */
@:allow(sk.thenet.plat.flash)
class Output implements sk.thenet.audio.IOutput {
  public var playing (default, null):Bool = false;
  public var channels(default, null):Int;
  public var samples (default, null):Int;
  
  private var sound:Sound;
  private var channel:SoundChannel;
  private var channelsSamples:Int;
  private var buffer:Vector<Float>;
  
  private function new(channels:Int = 2, samples:Int = 8192) {
    this.channels = channels;
    this.samples = samples;
    channelsSamples = channels * samples;
    sound = new Sound();
    sound.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSample);
    buffer = new Vector<Float>(channelsSamples);
    for (i in 0...channelsSamples) {
      buffer[i] = 0;
    }
  }
  
  public function play():Void {
    if (!playing) {
      channel = sound.play();
      playing = true;
    }
  }
  
  public function stop():Void {
    if (playing) {
      channel.stop();
      channel = null;
      playing = false;
    }
  }
  
  private function handleSample(event:SampleDataEvent):Void {
    sample(event.position, buffer);
    for (i in 0...channelsSamples) {
      event.data.writeFloat(buffer[i]);
    }
  }
  
  public dynamic function sample(offset:Float, buffer:Vector<Float>):Void {}
}

#end
