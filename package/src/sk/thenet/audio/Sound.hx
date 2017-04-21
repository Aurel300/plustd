package sk.thenet.audio;

/**
##Audio sample##

This is a `typedef` aliased to the current platform-dependent audio sample
implementation.

@see `sk.thenet.plat.Platform` for details and defining custom platforms.
@see `sk.thenet.audio.ISound` for methods and properties available in
implementations.
 */
typedef Sound =
#if flash
    sk.thenet.plat.flash.audio.Sound
#elseif js
    sk.thenet.plat.js.common.audio.Sound
#else
    ISound
#end
  ;

/**
##Audio loop mode##

Used in `Sound.play()`.
 */
enum LoopMode {
  /**
The sound is played once, then stops.
   */
  Once;
  
  /**
The sound repeats forever (unless stopped with `Sound.stop()`).
   */
  Forever;
  
  /**
The sound is repeated `amount` times.
   */
  Loop(amount:Int);
}