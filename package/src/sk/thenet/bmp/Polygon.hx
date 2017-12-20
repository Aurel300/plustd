package sk.thenet.bmp;

import haxe.ds.Vector;
import sk.thenet.geom.*;
import sk.thenet.stream.bmp.*;

using sk.thenet.FM;

/**
##Polygon rendering##

This is a software-based polygon renderer. High amounts of polygons or large
polygons will most likely result in slow performance.
 */
class Polygon {
  /**
Renders a polygon consisting of `pts` points onto the bitmap `to` using the
colour `c`. The polygon will always be rendered convex on the x axis.

@return Number of pixels drawn.
   */
  public static function plot(to:Bitmap, c:Colour, pts:Vector<Point2DI>):Int {
    var fill = new Vector<Int>(to.height << 1);
    var xmin = to.width;
    var xmax = 0;
    var ymin = to.height;
    var ymax = 0;
    for (p in pts) {
      xmin = xmin.minI(p.x);
      xmax = xmax.maxI(p.x);
      ymin = ymin.minI(p.y);
      ymax = ymax.maxI(p.y);
    }
    xmin = xmin.maxI(0);
    ymin = ymin.maxI(0);
    xmax = (to.width - 1).minI(xmax + 1);
    ymax = (to.height - 1).minI(ymax + 1);
    var j = ymin << 1;
    for (i in ymin...ymax) {
      fill[j]     = xmax;
      fill[j + 1] = xmin;
      j += 2;
    }
    for (pi in 0...pts.length) {
      for (p in Bresenham.getCurve(pts[pi], pts[(pi + 1) % pts.length])) {
        if (!p.y.withinI(0, to.height - 1)) continue;
        var p2 = p.y << 1;
        fill[p2]     = fill[p2].minI(p.x);
        fill[p2 + 1] = fill[p2 + 1].maxI(p.x);
      }
    }
    j = ymin << 1;
    for (i in ymin...ymax) {
      fill[j]     = fill[j].maxI(0);
      fill[j + 1] = fill[j + 1].minI(to.width - 1);
      j += 2;
    }
    var ret = 0;
    var xw = (xmax + 1) - xmin;
    var yh = (ymax + 1) - ymin;
    var vec = to.getVectorRect(xmin, ymin, xw, yh);
    var i = 0;
    var ly = 0;
    for (y in ymin...ymax) {
      i = fill[y << 1] - xmin + ly * xw;
      for (x in fill[y << 1]...fill[(y << 1) + 1]) {
        vec[i] = c;
        ret++;
        i++;
      }
      ly++;
    }
    to.setVectorRect(xmin, ymin, xw, yh, vec);
    return ret;
  }
}