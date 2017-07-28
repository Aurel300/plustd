package sk.thenet.plat.js.common.audio;

#if js

import haxe.ds.Vector;
import js.html.audio.*;

/**
JavaScript implementation of `sk.thenet.audio.IOutput`.

@see `sk.thenet.audio.IOutput`
 */
@:allow(sk.thenet.plat.js)
class Output implements sk.thenet.audio.IOutput {
  public var playing (default, null):Bool = false;
  public var channels(default, null):Int;
  public var samples (default, null):Int;
  
  private var outputContext:AudioContext;
  private var outputOscillator:OscillatorNode;
  private var outputNode:ScriptProcessorNode;
  private var channelsSamples:Int;
  private var buffer:Vector<Float>;
  private var time:Float;
  
  private function new(channels:Int = 2, samples:Int = 8192) {
    this.samples = samples;
    this.channels = channels;
    channelsSamples = samples * channels;
    buffer = new Vector<Float>(channelsSamples);
    for (i in 0...channelsSamples) {
      buffer[i] = 0;
    }
  }
  
  public function play():Void {
    if (!playing) {
      time = 0;
      playing = true;
      outputContext = new AudioContext();
      outputOscillator = outputContext.createOscillator();
      var buf = outputContext.createBuffer(2, samples, 44100);
      outputNode = outputContext.createScriptProcessor(samples, 1, 2);
      outputNode.onaudioprocess = handleSample;
      outputOscillator.connect(outputNode);
      outputNode.connect(outputContext.destination);
      outputOscillator.start(0);
    }
  }
  
  public function stop():Void {
    if (playing) {
      playing = false;
      outputOscillator.stop();
      outputOscillator.disconnect();
      outputNode.disconnect();
    }
  }
  
  private function handleSample(event:AudioProcessingEvent):Void {
    sample(time, buffer);
    time += samples;
    var outLeft:js.html.Float32Array = event.outputBuffer.getChannelData(0);
    var outRight:js.html.Float32Array = event.outputBuffer.getChannelData(1);
    var i:Int = 0;
    var i2:Int = 0;
    while (i2 < channelsSamples) {
      outLeft[i] = buffer[i2++];
      outRight[i] = buffer[i2++];
      i++;
    }
  }
  
  public dynamic function sample(offset:Float, buffer:Vector<Float>):Void {}
}

#end
