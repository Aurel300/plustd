package sk.thenet.stream.bmp;

import sk.thenet.FM;
import sk.thenet.geom.Point2DF;
import sk.thenet.geom.Point2DI1DF;
import sk.thenet.stream.Stream;

class XiaolinWu extends Stream<Point2DI1DF> {
  public function new(from:Point2DF, to:Point2DF, ?ray:Bool = false){
    var steep = FM.absF(to.y - from.y) > FM.absF(to.x - from.x);
    var x1:Float = from.x;
    var y1:Float = from.y;
    var x2:Float = to.x;
    var y2:Float = to.y;
    var t:Float = 0;
    if (steep){
      t = x1; x1 = y1; y1 = t;
      t = x2; x2 = y2; y2 = t;
    }
    if (x1 > x2){
      t = x1; x1 = x2; x2 = t;
      t = y1; y1 = y2; y2 = t;
    }
    
    var dx:Float = x2 - x1;
    var dy:Float = y2 - y1;
    var grad:Float = dy / dx;
    
    var xend:Int = FM.round(x1);
    var yend:Float = y1 + grad * (xend - x1);
    var xgap:Float = 1 - FM.frac(x1 + .5);
    
    var xpxl1:Int = xend;
    var ypxl1:Int = FM.floor(yend);
    
    var end11 = (steep
      ? new Point2DI1DF(ypxl1, xpxl1, (1 - FM.frac(yend)) * xgap)
      : new Point2DI1DF(xpxl1, ypxl1, (1 - FM.frac(yend)) * xgap));
    var end12 = (steep
      ? new Point2DI1DF(ypxl1 + 1, xpxl1, FM.frac(yend) * xgap)
      : new Point2DI1DF(xpxl1, ypxl1 + 1, FM.frac(yend) * xgap));
    
      /*
      bd.setAlpha(ypxl1, xpxl1, c, (1 - FM.frac(yend)) * xgap);
      bd.setAlpha(xpxl1, ypxl1, c, (1 - FM.frac(yend)) * xgap);

      bd.setAlpha(ypxl1 + 1, xpxl1, c, FM.frac(yend) * xgap);
      bd.setAlpha(xpxl1, ypxl1 + 1, c, FM.frac(yend) * xgap);
      */
    
    var intery:Float = yend + grad;
    
    xend = FM.round(x2);
    yend = y2 + grad * (xend - x2);
    xgap = FM.frac(x2 + .5);
    
    var xpxl2:Int = xend;
    var ypxl2:Int = FM.floor(yend);
    
    var end21 = (steep
      ? new Point2DI1DF(ypxl2, xpxl2, (1 - FM.frac(yend)) * xgap)
      : new Point2DI1DF(xpxl2, ypxl2, (1 - FM.frac(yend)) * xgap));
    var end22 = (steep
      ? new Point2DI1DF(ypxl2 + 1, xpxl2, FM.frac(yend) * xgap)
      : new Point2DI1DF(xpxl2, ypxl2 + 1, FM.frac(yend) * xgap));
    
    var ends = []; //[end11, end12, end21, end22];
    
    var x:Int = (xpxl1 + 1);
    var ph:Bool = false;
    
    super(ray ? Stream.always : function():Bool {
        return (ray || ends.length > 0 || x < xpxl2);
      }, function():Point2DI1DF {
        if (ends.length > 2){
          return ends.shift();
        } else if (ray || x < xpxl2){
          if (!ph){
            ph = true;
            return (steep
              ? new Point2DI1DF(FM.floor(intery), x, 1 - FM.frac(intery))
              : new Point2DI1DF(x, FM.floor(intery), 1 - FM.frac(intery)));
          }
          ph = false;
          var ret = (steep
            ? new Point2DI1DF(FM.floor(intery) + 1, x, FM.frac(intery))
            : new Point2DI1DF(x, FM.floor(intery) + 1, FM.frac(intery)));
          intery += grad;
          x++;
          return ret;
        }
        return ends.shift();
      });
  }
}
