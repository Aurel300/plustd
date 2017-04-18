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
#if flash
    sk.thenet.plat.flash.net.Socket
#elseif neko
    sk.thenet.plat.neko.Socket
#else
    ISocket
#end
  ;
