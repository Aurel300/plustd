package sk.thenet.bmp;

import sk.thenet.bmp.ISurface;

/**
##Surface##

This is a `typedef` aliased to the current platform-dependent surface
implementation.

@see `sk.thenet.plat.Platform` for details and defining custom platforms.
@see `sk.thenet.bmp.ISurface` for methods and properties available in
implementations.
 */
typedef Surface =
#if flash
    sk.thenet.plat.flash.bmp.Surface
#elseif js
    sk.thenet.plat.jsca.bmp.Surface
#else
    ISurface
#end
  ;
