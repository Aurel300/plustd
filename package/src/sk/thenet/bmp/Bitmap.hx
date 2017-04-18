package sk.thenet.bmp;

import sk.thenet.bmp.IBitmap;

/**
##Bitmap##

This is a `typedef` aliased to the current platform-dependent bitmap
implementation.

@see `sk.thenet.plat.Platform` for details and defining custom platforms.
@see `sk.thenet.bmp.IBitmap` for methods and properties available in
implementations.
 */
typedef Bitmap =
#if flash
    sk.thenet.plat.flash.bmp.Bitmap
#else
    IBitmap
#end
  ;
