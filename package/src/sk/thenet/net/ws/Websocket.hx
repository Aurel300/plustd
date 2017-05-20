package sk.thenet.net.ws;

/**
##Webocket##

This is a `typedef` aliased to the current platform-dependent Websocket
implementation.

@see `sk.thenet.plat.Platform` for details and defining custom platforms.
@see `sk.thenet.net.ws.IWebsocket` for methods and properties available in
implementations.
 */
typedef Websocket =
#if ((PLUSTD_TARGET == "js.canvas") || (PLUSTD_TARGET == "js.webgl"))
    sk.thenet.plat.js.common.net.ws.Websocket
#else
    sk.thenet.plat.common.net.ws.Websocket
#end
  ;
