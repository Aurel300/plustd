package sk.thenet.app;

/**
##Embedded resources##

This is a `typedef` aliased to the current platform-dependent embed
implementation.

@see `sk.thenet.plat.Platform` for details and defining custom platforms.
 */
typedef Embed =
#if flash
    sk.thenet.plat.flash.app.Embed
#elseif js
    sk.thenet.plat.js.canvas.app.Embed
#else
    Void
#end
  ;
