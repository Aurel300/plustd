package sk.thenet.geom.poly;

import haxe.macro.Context;
import haxe.macro.Expr;

/**
##N-cube##

This class has macro functions to generate the points and lines of an n-cube
(line, square, cube, tesseract, ...).
 */
class Cube {
  /**
Produces an array of `1 << dim` points. If `isInt` is left as `true`, the
points generated will be `Point*DI`, pass `false` to get the floating variants
`Point*DF`.
   */
  public static macro function makePoints(?dim:Int = 3, ?isInt:Bool = true):Expr {
    var pname = "Point" + dim + "D" + (isInt ? "I" : "F");
    return Context.parse('[' + [ for (p in 0...1 << dim)
        'new ${pname}(' + [ for (i in 0...dim) (p & (1 << i) != 0 ? 1 : 0) ].join(", ") + ')'
      ].join(", ") + ']', Context.currentPos());
  }
  
  /**
Produces an array of 2-element arrays which indicate which indices in the array
produced by `makePoints` should be connected.
   */
  public static macro function makeLines(?dim:Int = 3):Expr {
    return Context.parse('[' + [ for (p in 0...1 << dim)
        for (i in 0...dim) if (p & (1 << i) == 0) '[$p, ${p | (1 << i)}]'
      ].join(", ") + ']', Context.currentPos());
  }
}
