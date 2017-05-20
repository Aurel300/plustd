package sk.thenet.format.bmp;

/**
##Format - PNG##

This class defines a PNG encoder and decoder.

####Encoding####

Encoding supports a variety of colour types, as well as automatic detection. By
default, however, the encoder will only encode in RGBA colour format. If a
smaller filesize is desired and possible (e.g. when encoding pixel art images or
images with a very limited colour palette), the values in
`PNG.encodeColourTypes` should be set to `true`.

The encoder currently supports:

Colour types:

 - `0` grayscale
 - `2` truecolour (RGB)
 - `3` indexed (and indexed with alpha channel)
 - `4` grayscale and alpha
 - `6` truecolour and alpha (RGBA)

Bit depths lower than `8` for colour types `0` and `3`.

####Decoding####

The decoder currently supports:

Colour types:

 - `2` truecolour (RGB)
 - `6` truecolour and alpha (RGBA)

Bit depth `8`.
 */
typedef PNG =
#if ((PLUSTD_TARGET == "cppsdl.desktop") || (PLUSTD_TARGET == "cppsdl.phone"))
    sk.thenet.plat.cppsdl.common.format.bmp.PNG
// #elseif js
//     sk.thenet.plat.js.common.format.bmp.PNG
#else
    sk.thenet.plat.common.format.bmp.PNG
#end
  ;
