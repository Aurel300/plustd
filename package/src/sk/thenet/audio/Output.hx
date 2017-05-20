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
#if ((PLUSTD_TARGET == "cppsdl.desktop") || (PLUSTD_TARGET == "cppsdl.phone"))
    sk.thenet.plat.cppsdl.common.audio.Output
#elseif (PLUSTD_TARGET == "flash")
    sk.thenet.plat.flash.audio.Output
#elseif ((PLUSTD_TARGET == "js.canvas") || (PLUSTD_TARGET == "js.webgl"))
    sk.thenet.plat.js.common.audio.Output
#else
    IOutput
#end
  ;
