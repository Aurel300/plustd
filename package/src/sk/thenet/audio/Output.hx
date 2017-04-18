package sk.thenet.audio;

/**
##Audio output##

This is a `typedef` aliased to the current platform-dependent audio output
implementation.

@see `sk.thenet.plat.Platform` for details and defining custom platforms.
@see `sk.thenet.audio.IOutput` for methods and properties available in
implementations.
 */
typedef Output =
#if flash
    sk.thenet.plat.flash.audio.Output
#elseif js
    sk.thenet.plat.jsca.audio.Output
#else
    IOutput
#end
  ;
