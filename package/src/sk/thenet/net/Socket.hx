package sk.thenet.net;

/**
##Socket##

This is a `typedef` aliased to the current platform-dependent socket
implementation.

@see `sk.thenet.plat.Platform` for details and defining custom platforms.
@see `sk.thenet.bmp.ISocket` for methods and properties available in
implementations.
 */
typedef Socket =
#if (PLUSTD_TARGET == "flash")
    sk.thenet.plat.flash.net.Socket
#elseif (PLUSTD_TARGET == "neko")
    sk.thenet.plat.neko.Socket
#else
    ISocket
#end
  ;
