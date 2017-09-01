package sk.thenet.geom.poly;

import haxe.macro.Context;
import haxe.macro.Expr;

class Cube {
  public static macro function makePoints(?dim:Int = 3, ?isInt:Bool = true):Expr {
    var pname = "Point" + dim + "D" + (isInt ? "I" : "F");
    return Context.parse('[' + [ for (p in 0...1 << dim)
        'new ${pname}(' + [ for (i in 0...dim) (p & (1 << i) != 0 ? 1 : 0) ].join(", ") + ')'
      ].join(", ") + ']', Context.currentPos());
  }
  
  public static macro function makeLines(?dim:Int = 3):Expr {
    return Context.parse('[' + [ for (p in 0...1 << dim)
        for (i in 0...dim) if (p & (1 << i) == 0) '[$p, ${p | (1 << i)}]'
      ].join(", ") + ']', Context.currentPos());
  }
}
