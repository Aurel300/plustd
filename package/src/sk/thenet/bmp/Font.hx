package sk.thenet.bmp;

import haxe.ds.Vector;
import sk.thenet.bmp.Bitmap;
import sk.thenet.plat.Platform;

/**
##Bitmap font##

This class can be used to create and render bitmap fonts.
 */
class Font {
  private static inline var RECT_SIZE:Int = 6;
  
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
    for (i in 0...characters){
      rects[i * RECT_SIZE] = x;
      rects[i * RECT_SIZE + 1] = y;
      rects[i * RECT_SIZE + 2] = characterWidth;
      rects[i * RECT_SIZE + 3] = characterHeight;
      rects[i * RECT_SIZE + 4] = characterWidth + offsetWidth;
      rects[i * RECT_SIZE + 5] = characterHeight + offsetHeight;
      x += characterWidth;
      xi++;
      if (xi >= charactersPerLine){
        xi = 0;
        x = 0;
        y += characterHeight;
      }
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
    for (y in 0...gridHeight) for (x in 0...gridWidth){
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
  
  private var offset:Int;
  private var rects:Vector<Int>;
  
  private function new(data:Bitmap, offset:Int, rects:Vector<Int>){
    this.data = data;
    this.offset = offset;
    this.rects = rects;
  }
  
  /**
Renders the given `text` to the given `target` bitmap at the point `(x, y)`.
   */
  public function render(target:Bitmap, x:Int, y:Int, text:String):Void {
    var cx:Int = x;
    var cy:Int = y;
    for (i in 0...text.length){
      var ch = text.charAt(i);
      var cc = text.charCodeAt(i);
      switch (ch){
        case "\n":
        cx = x;
        cy += rects[3];
        
        case _ if (cc >= offset && cc < offset + rects.length):
        cc = (cc - offset) * RECT_SIZE;
        if (FM.withinI(cx, 0, target.width - 1)
            && FM.withinI(cy, 0, target.height - 1)){
          target.blitAlphaRect(
               data, cx, cy
              ,rects[cc], rects[cc + 1], rects[cc + 2], rects[cc + 3]
            );
        }
        cx += rects[cc + 4];
        
        case _:
      }
    }
  }
}
