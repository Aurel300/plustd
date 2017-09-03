package sk.thenet.bmp;

import haxe.ds.Vector;
import sk.thenet.M;
import sk.thenet.bmp.Bitmap;
import sk.thenet.geom.Point2DI;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

/**
##Bitmap font##

This class can be used to create and render bitmap fonts.
 */
class Font {
  public static inline var RECT_SIZE:Int = 6;
  
  /**
Creates a monospaced font. The bitmap given should contain the necessary
characters arranged in a grid.

@param data Bitmap containing the necessary characters.
@param asciiOffset The ASCII value of the first character in the font.
@param characters Number of characters in the font.
@param characterWidth Width of a single character (in the grid).
@param characterHeight Height of a single character (in the grid).
@param charactersPerLine Number of characters on a single line of the grid.
@param offsetWidth Offset to the resulting width of characters.
@param offsetHeight Offset to the resulting height of characters.
   */
  public static function makeMonospaced(
     data:Bitmap, asciiOffset:Int, characters:Int
    ,characterWidth:Int, characterHeight:Int
    ,charactersPerLine:Int
    ,?offsetWidth:Int = 0, ?offsetHeight:Int = 0
  ):Font {
    var rects = new Vector<Int>(characters * RECT_SIZE);
    var x:Int = 0;
    var y:Int = 0;
    var xi:Int = 0;
    for (i in 0...characters) {
      rects[i * RECT_SIZE] = x;
      rects[i * RECT_SIZE + 1] = y;
      rects[i * RECT_SIZE + 2] = characterWidth;
      rects[i * RECT_SIZE + 3] = characterHeight;
      rects[i * RECT_SIZE + 4] = characterWidth + offsetWidth;
      rects[i * RECT_SIZE + 5] = characterHeight + offsetHeight;
      x += characterWidth;
      xi++;
      if (xi >= charactersPerLine) {
        xi = 0;
        x = 0;
        y += characterHeight;
      }
    }
    return new Font(data, asciiOffset, rects);
  }
  
  /**
Creates a font with automatic spacing. This does not create a kerning table,
it only estimates the width of each character by recording its widest point.
The bitmap given should contain the necessary characters arranged in a grid.

@param data Bitmap containing the necessary characters.
@param asciiOffset The ASCII value of the first character in the font.
@param characters Number of characters in the font.
@param characterWidth Width of a single character (in the grid).
@param characterHeight Height of a single character (in the grid).
@param charactersPerLine Number of characters on a single line of the grid.
@param offsetWidth Offset to the resulting width of characters.
@param offsetHeight Offset to the resulting height of characters.
   */
  public static function makeAutospaced(
     data:Bitmap, asciiOffset:Int, characters:Int
    ,characterWidth:Int, characterHeight:Int
    ,charactersPerLine:Int
    ,?offsetWidth:Int = 0, ?offsetHeight:Int = 0
  ):Font {
    var rects = new Vector<Int>(characters * RECT_SIZE);
    var x:Int = 0;
    var y:Int = 0;
    var xi:Int = 0;
    for (i in 0...characters) {
      var xmin = characterWidth;
      var xmax = 0;
      for (cy in y...y + characterHeight) {
        for (cx in x...x + characterWidth) {
          if (!data.get(cx, cy).isTransparent) {
            var cxo = cx - x;
            if (cxo < xmin) {
              xmin = cxo;
            }
            cxo++;
            if (cxo > xmax) {
              xmax = cxo;
            }
          }
        }
      }
      var rwidth = (xmax - xmin) + 1;
      rects[i * RECT_SIZE] = x + xmin;
      rects[i * RECT_SIZE + 1] = y;
      rects[i * RECT_SIZE + 2] = rwidth.minI(characterWidth);
      rects[i * RECT_SIZE + 3] = characterHeight;
      rects[i * RECT_SIZE + 4] = rwidth + offsetWidth;
      rects[i * RECT_SIZE + 5] = characterHeight + offsetHeight;
      x += characterWidth;
      xi++;
      if (xi >= charactersPerLine) {
        xi = 0;
        x = 0;
        y += characterHeight;
      }
    }
    var spaceId = (32 - asciiOffset) * RECT_SIZE + 4;
    if (spaceId.withinV(rects)) {
      rects[spaceId] = characterWidth;
    }
    return new Font(data, asciiOffset, rects);
  }
  
  /**
Takes a bitmap grid of characters and adds spacing to each character, then
returns the wider grid.

@param data Input grid.
@param characterWidth Width of a single character (in the grid).
@param characterHeight Height of a single character (in the grid).
@param addX1 Empty pixels to be added to the left of each character.
@param addX2 Empty pixels to be added to the right of each character.
@param addY1 Empty pixels to be added above each character.
@param addY2 Empty pixels to be added below each character.
   */
  public static function spreadGrid(
     data:Bitmap
    ,characterWidth:Int, characterHeight:Int
    ,addX1:Int, addX2:Int, addY1:Int, addY2:Int
  ):Bitmap {
    var gridWidth:Int = Std.int(data.width / characterWidth);
    var gridHeight:Int = Std.int(data.height / characterHeight);
    var ret = Platform.createBitmap(
         gridWidth * (characterWidth + addX1 + addX2)
        ,gridHeight * (characterHeight + addY1 + addY2)
        ,0
      );
    for (y in 0...gridHeight) for (x in 0...gridWidth) {
      ret.blitAlphaRect(
           data
          ,x * (characterWidth + addX1 + addX2) + addX1
          ,y * (characterHeight + addY1 + addY2) + addY1
          ,x * characterWidth, y * characterHeight
          ,characterWidth, characterHeight
        );
    }
    return ret;
  }
  
  /**
Source bitmap data for the font.
   */
  public var data(default, null):Bitmap;
  
  /**
Coordinates and numerical data for individual characters. Data for any
character is stored at `rects[(ascii - offset) * RECT_SIZE + n]`, where `n` is:

 - 0 - x position of character in `data`
 - 1 - y position of character in `data`
 - 2 - width of character
 - 3 - height of character
 - 4 - amount to move the rendering x coordinate after rendering character
 - 5 - amount to move the rendering y coordinate after rendering character

(`5` is only used for newline.)
   */
  public var rects:Vector<Int>;
  
  /**
ASCII offset for the first character in this font.
   */
  public var offset:Int;
  
  private function new(data:Bitmap, offset:Int, rects:Vector<Int>) {
    this.data = data;
    this.offset = offset;
    this.rects = rects;
  }
  
  /**
Renders the given `text` to the given `target` bitmap at the point `(x, y)`.

The additional parameters can be used to achieve a (very simple) paragraph
indent - if the given `sx` is smaller than `x`, any lines following the first
will be to the left of the first.

If `fbuffer` is not `null`, a special syntax is enabled: `$A` switches the
rendering font to `fbuffer[0]`, `$B` to `fbuffer[1]`, etc. `$$` can be used when
a dollar sign is needed.

@param target Bitmap to which the text will be rendered.
@param x X coordinate at which to start rendering the text.
@param y Y coordinate at which to start rendering the text.
@param text The message to render.
@param sx Starting x coordinate (x is reset to this on new lines). Defaults to
`x`.
@param sy Starting y coordinate. Defaults to `y`.
@param fbuffer An array of fonts that can be chosen using the syntax described
above.
   */
  public function render(
     target:Bitmap, x:Int, y:Int, text:String
    ,?sx:Int, ?sy:Int, ?fbuffer:Array<Font>
  ):Point2DI {
    sx = M.denull(sx, x);
    sy = M.denull(sy, y);
    var xmax = x;
    var ymax = y;
    var i = 0;
    while (i < text.length) {
      var ch = text.charAt(i);
      var cc = text.charCodeAt(i);
      var cr = (cc - offset) * RECT_SIZE;
      inline function renderChar():Void {
        if (   FM.withinI(x, -rects[cr + 2], target.width  - 1 + rects[cr + 2])
            && FM.withinI(y, -rects[cr + 3], target.height - 1 + rects[cr + 3])) {
          target.blitAlphaRect(
               data, x, y
              ,rects[cr], rects[cr + 1], rects[cr + 2], rects[cr + 3]
            );
        }
        x += rects[cr + 4];
      }
      switch (ch) {
        case "\n":
        x = sx;
        y += rects[5];
        
        case "$" if (i < text.length - 1 && fbuffer != null):
        if (text.charAt(i + 1) == "$"
            || !FM.withinI(text.charCodeAt(i + 1) - 65, 0, fbuffer.length - 1)) {
          if (cc >= offset && cc < offset + rects.length) {
            renderChar();
          }
          i++;
        } else {
          var subret = fbuffer[text.charCodeAt(i + 1) - 65].render(
              target, x, y, text.substr(i + 2), sx, sy, fbuffer
            );
          return new Point2DI(FM.maxI(xmax, subret.x), FM.maxI(ymax, subret.y));
        }
        
        case _ if (cc >= offset && cc < offset + rects.length):
        renderChar();
        
        case _:
      }
      if (cc >= offset && cc < offset + rects.length) {
        if (x + rects[cr + 4] > xmax) xmax = x + rects[cr + 4];
      }
      if (y + rects[5] > ymax) ymax = y + rects[5];
      i++;
    }
    return new Point2DI(xmax, ymax);
  }
  
  public inline function getRect(char:Int, n:Int):Int {
    return rects[(char - offset) * RECT_SIZE + n];
  }
}
