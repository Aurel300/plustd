package sk.thenet.audio;

import haxe.ds.Vector;

/**
##Audio output##

This interface represents a code-generated audio output.

Implementations of this interface are platform-dependent, thus they can be
found in `sk.thenet.plat`. To actually create a `Output`, use
`sk.thenet.plat.Platform.createAudioOutput()`.

Implementations of this interface are platform-dependent. To maintain good
performance without having to actually cast classes to this interface, there
is a typedef available - `sk.thenet.plat.Output` - which becomes an alias for
the current platform-dependent implementation of `IOutput` at compile time. To
actually create an `Output`, use `sk.thenet.plat.Platform.createAudioOutput()`.
 */
interface IOutput {
  /**
Starts buffering data and outputting it via the system audio output.
   */
  public function play():Void;
  
  /**
Called to sample data to be played by the audio card.

@param offset Time offset between this event and the original `play()` call.
@param buffer Buffer into which data should be written.
   */
  public dynamic function sample(offset:Float, buffer:Vector<Float>):Void;
  
  /**
Stops the playback.
   */
  public function stop():Void;
}
