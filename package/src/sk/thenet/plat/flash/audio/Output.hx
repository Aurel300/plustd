package sk.thenet.plat.flash.audio;

import haxe.ds.Vector;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.events.SampleDataEvent;

/**
Flash implementation of `sk.thenet.audio.IOutput`.

@see `sk.thenet.audio.IOutput`
 */
class Output implements sk.thenet.audio.IOutput {
  private var sound:Sound;
  private var channel:SoundChannel;
  private var playing:Bool;
  private var samples:Int;
  private var channels:Int;
  private var channelsSamples:Int;
  private var buffer:Vector<Float>;
  
  public function new(?samples:Int = 8192, ?channels:Int = 2){
    sound = new Sound();
    sound.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSample);
    playing = false;
    this.samples = samples;
    this.channels = channels;
    channelsSamples = samples * channels;
    buffer = new Vector<Float>(channelsSamples);
    for (i in 0...channelsSamples){
      buffer[i] = 0;
    }
  }
  
  public function play():Void {
    if (!playing){
      channel = sound.play();
      playing = true;
    }
  }
  
  public function stop():Void {
    if (playing){
      channel.stop();
      channel = null;
      playing = false;
    }
  }
  
  private function handleSample(event:SampleDataEvent):Void {
    sample(event.position, buffer);
    for (i in 0...channelsSamples){
      event.data.writeFloat(buffer[i]);
    }
  }
  
  public dynamic function sample(offset:Float, buffer:Vector<Float>):Void {};
}
