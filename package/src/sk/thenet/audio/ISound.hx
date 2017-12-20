package sk.thenet.audio;

import sk.thenet.audio.Sound.LoopMode;

/**
##Audio sample##

This interface represents an audio sample.

Implementations of this interface are platform-dependent. To maintain good
performance without having to actually cast classes to this interface, there
is a typedef available - `sk.thenet.audio.Sound` - which becomes an alias for
the current platform-dependent implementation of `ISound` at compile time.
To actually create a `Sound`, use the `sk.thenet.app.Embed` resources.
 */
interface ISound {
  /**
`true` iff there is at least one channel currently playing this sample.
   */
  public var playing(get, null):Bool;
  
  /**
Plays the sample with the given loop mode. This will create a new channel, and
it won't stop the playback of any previous channels of this sound.
   */
  public function play(?mode:LoopMode, ?volume:Float):IChannel;
  
  /**
Stops the playback of this sound on all channels.
   */
  public function stop():Void;
}