package sk.thenet.bmp;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

class Flood {
  public static function floodOpaque(
     vec:Vector<Colour>, w:Int, h:Int, x:Int, y:Int, clear:Colour = Colour.BLACK
    ,sameColour:Bool = false
  ):{minX:Int, maxX:Int, minY:Int, maxY:Int, fill:Bitmap} {
    var exp = new Vector<Bool>(vec.length);
    var minX = w;
    var minY = h;
    var maxX = 0;
    var maxY = 0;
    var startColour = vec[x + y * w];
    var queueI = [x + y * w];
    var queueX = [x];
    var queueY = [y];
    exp[queueI[0]] = true;
    while (queueI.length > 0) {
      var i = queueI.shift();
      var x = queueX.shift();
      var y = queueY.shift();
      minX = FM.minI(minX, x);
      minY = FM.minI(minY, y);
      maxX = FM.maxI(maxX, x);
      maxY = FM.maxI(maxY, y);
      inline function check(ox:Int, oy:Int):Void {
        var ni = i + ox + oy * w;
        if ((x + ox).withinI(0, w - 1) && (y + oy).withinI(0, h - 1)
            && exp[ni] != true && !vec[ni].isTransparent
            && (!sameColour || vec[ni] == startColour)) {
          exp[ni] = true;
          queueI.push(ni);
          queueX.push(x + ox);
          queueY.push(y + oy);
        }
      }
      check(-1, 0);
      check(1, 0);
      check(0, -1);
      check(0, 1);
    }
    if (minX > maxX || minY > maxY) {
      return null;
    }
    var fill = Platform.createBitmap(maxX + 1 - minX, maxY + 1 - minY, 0);
    for (y in minY...maxY + 1) for (x in minX...maxX + 1) {
      if (exp[x + y * w] == true) {
        fill.set(x - minX, y - minY, clear);
      }
    }
    return {minX: minX, maxX: maxX, minY: minY, maxY: maxY, fill: fill};
  }
}
