package sk.thenet.plat;

import sk.thenet.audio.IOutput;

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
    sk.thenet.plat.flash.Output
#else
    IOutput
#end
  ;
