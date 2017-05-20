package sk.thenet.bmp;

/**
##Bitmap##

This is a `typedef` aliased to the current platform-dependent bitmap
implementation.

@see `sk.thenet.plat.Platform` for details and defining custom platforms.
@see `sk.thenet.bmp.IBitmap` for methods and properties available in
implementations.
 */
typedef Bitmap =
#if ((PLUSTD_TARGET == "cppsdl.desktop") || (PLUSTD_TARGET == "cppsdl.phone"))
    sk.thenet.plat.cppsdl.common.bmp.Bitmap
#elseif (PLUSTD_TARGET == "flash")
    sk.thenet.plat.flash.bmp.Bitmap
#elseif (PLUSTD_TARGET == "js.canvas")
    sk.thenet.plat.js.canvas.bmp.Bitmap
//#elseif (PLUSTD_TARGET == "js.webgl")
//    sk.thenet.plat.js.webgl.bmp.Bitmap
#else
    sk.thenet.plat.common.bmp.Bitmap
#end
  ;
