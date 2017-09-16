package sk.thenet.app;

/**
##Embedded resources##

This is a `typedef` aliased to the current platform-dependent embed
implementation.

@see `sk.thenet.plat.Platform` for details and defining custom platforms.
 */

typedef Embed =
#if ((PLUSTD_TARGET == "cppsdl.desktop") || (PLUSTD_TARGET == "cppsdl.phone"))
    sk.thenet.plat.cppsdl.common.app.Embed
#elseif (PLUSTD_TARGET == "neko")
    sk.thenet.plat.neko.app.Embed
#elseif (PLUSTD_TARGET == "flash")
    sk.thenet.plat.flash.app.Embed
#elseif (PLUSTD_TARGET == "js.canvas")
    sk.thenet.plat.js.canvas.app.Embed
//#elseif (PLUSTD_TARGET == "js.webgl")
//    sk.thenet.plat.js.webgl.app.Embed
#else
    Void
#end
  ;
