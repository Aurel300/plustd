package sk.thenet.bmp;

import haxe.ds.Vector;
import sk.thenet.plat.Bitmap;

/**
##Bitmap interface##

This interface represents a two-dimensional image consisting of 32-bit ARGB
(alpha, red, green, blue; 8 bits per channel) values. It supports pixel
manipulation by getting / setting individual pixels (`Bitmap.get()` and
`Bitmap.set()`) or by getting / setting vectors. In almost all cases,
the latter has much better performance because there is no function-call
overhead for every single pixel.

Implementations of this interface are platform-dependent. To maintain good
performance without having to actually cast classes to this interface, there
is a typedef available - `sk.thenet.plat.Bitmap` - which becomes an alias for
the current platform-dependent implementation of `IBitmap` at compile time. To
actually create a `Bitmap`, use `sk.thenet.plat.Platform.createBitmap()`.

Many common bitmap operations were abstracted into the `bmp.manip` package,
instead of being members of this interface.

Note on the nomenclature: The Flash equivalent to this is
`flash.display.BitmapData`, not `flash.display.Bitmap`.
 */
interface IBitmap {
  /**
The height of this bitmap, in pixels.
   */
  public var height(default, null):Int;
  
  /**
The width of this bitmap, in pixels.
   */
  public var width(default, null):Int;
  
  /**
The `sk.thenet.bmp.FluentBitmap` for this bitmap.
   */
  public var fluent(get, never):FluentBitmap;
  
  /**
Attempting to read from coordinates outside the bounds of this bitmap will
return `0`.

@return 32-bit ARGB colour of the pixel at `(x, y)`.
   */
  public function get(x:Int, y:Int):UInt;
  
  /**
Sets the colour of the pixel at `(x, y)` to the given 32-bit ARGB colour. If
writing outside the bounds of this bitmap, nothing happens.
   */
  public function set(x:Int, y:Int, colour:Colour):Void;
  
  /**
This function creates a vector for the entire bitmap. As noted in the class
description, bitmap operations using vectors are usually faster than
pixel-by-pixel manipulation. To get the  colour of the pixel at `(x, y)`, use
`vector[x + y * width]`.

The result of this function is never the same vector. To overwrite the data
in this bitmap, use `setVector()` with the modified vector.

@return A `haxe.ds.Vector` representing every pixel of this bitmap.
   */
  public function getVector():Vector<UInt>;
  
  /**
See `getVector()` for vector format.

Overwrites the pixels in this bitmap using the given vector.
   */
  public function setVector(vector:Vector<Colour>):Void;
  
  /**
See `getVector()` for vector format.

This function creates a vector for the region of pixels within the rectangle
whose top-left point is at `(x, y)`, is `width` wide, and `height` tall.

The rectangle gets clamped to the bounds of this bitmap.

@return A `haxe.ds.Vector` representing the pixels in the specified region
of this bitmap.
   */
  public function getVectorRect(
    x:Int, y:Int, width:Int, height:Int
  ):Vector<UInt>;
  
  /**
See `getVector()` for vector format.

Overwrites the pixels in the region of pixels within the rectangle whose
top-left point is at `(x, y)`, is `width` wide, and `height` tall using the
given vector.

The rectangle is *first* clamped to the bounds of this bitmap, then data is
overwritten.

@return A `haxe.ds.Vector` representing the pixels in the specified region
of this bitmap.
   */
  public function setVectorRect(
    x:Int, y:Int, width:Int, height:Int, vector:Vector<Colour>
  ):Void;
  
  /**
Replaces every pixel of this bitmap with the given colour.
   */
  public function fill(colour:Colour):Void;
  
  /**
Replaces every pixel in the rectangle whose top-left point is at `(x, y)`, is
`width` wide, and `height` tall with the given colour.
   */
  public function fillRect(
    x:Int, y:Int, width:Int, height:Int, colour:Colour
  ):Void;
  
  /**
Copies the (entire) given bitmap onto this one at `(x, y)`, using alpha blending
in case of transparency.
   */
  public function blitAlpha(src:Bitmap, x:Int, y:Int):Void;
  
  /**
Copies a region of the given bitmap defined by the rectangle whose top-left
point is at `(srcX, srcY)`, is `srcW` wide, and `srcH` tall onto this bitmap at
`(dstX, dstY)`, using alpha blending in case of transparency.
   */
  public function blitAlphaRect(
    src:Bitmap, dstX:Int, dstY:Int, srcX:Int, srcY:Int, srcW:Int, srcH:Int
  ):Void;
}
