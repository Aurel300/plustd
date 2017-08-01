package sk.thenet.ui;

import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.geom.Point2DI;
import sk.thenet.ui.disp.*;

class DisplayBuilder {
  public static function build(list:Array<DisplayType>):Array<Display> {
    function buildSub(
      last:Display, list:Array<DisplayType>, z:Int
    ):Array<Display> {
      if (list == null) {
        return [];
      }
      var ret = [];
      for (l in list) switch (l) {
        case WithName(name) if (last != null): last.name = name;
        case WithX(x) if (last != null): last.x = x;
        case WithY(y) if (last != null): last.y = y;
        case WithXY(x, y) if (last != null): last.x = x; last.y = y;
        case WithShow(show) if (last != null): last.show = show;
        
        case Table(w, cellW, cellH, ch) if (last != null):
        var tch = buildSub(last, ch, z);
        for (i in 0...tch.length) {
          tch[i].x = (i % w) * cellW;
          tch[i].y = FM.floor(i / w) * cellH;
        }
        
        case Center(w, h, ch) if (last != null):
        var wh = w >> 1;
        var hh = h >> 1;
        var tch = buildSub(last, ch, z);
        for (i in 0...tch.length) {
          tch[i].x = wh - (tch[i].w >> 1);
          tch[i].y = hh - (tch[i].h >> 1);
        }
        
        case WithName(_) | WithX(_) | WithY(_) | WithXY(_, _) | WithShow(_) | Table(_, _, _, _):
        throw "invalid modifier";
        
        case _:
        var ch = null;
        var parent = (switch (l) {
            case Panel(bmp, cch): ch = cch; new Panel(
                bmp, 0, 0, z, bmp == null ? 1 : bmp.width, bmp == null ? 1 : bmp.height
              );
            case SolidPanel(col, w, h, cch): ch = cch; new SolidPanel(
                col, 0, 0, z, w, h
              );
            case Clip(w, h, cch): ch = cch; new Panel(
                null, 0, 0, z, w, h, true
              );
            case BoxPanel(bmp, cut1, cut2, w, h, cch): ch = cch; new BoxPanel(
                bmp, cut1, cut2, 0, 0, z, w, h
              );
            case Button(bmp, bmpOver, bmpDown, cch): ch = cch; new Button(
                bmp, bmpOver, bmpDown, 0, 0, z, bmp == null ? 1 : bmp.width, bmp == null ? 1 : bmp.height
              );
            case BoxButton(bmp, bmpOver, bmpDown, cut1, cut2, w, h, cch): ch = cch; new BoxButton(
                bmp, bmpOver, bmpDown, cut1, cut2, 0, 0, z, w, h
              );
            case _: null;
          });
        parent.parent = last;
        if (last != null) {
          last.children.push(parent);
        }
        ret.push(parent);
        buildSub(parent, ch, z + 1);
      }
      return ret;
    }
    return buildSub(null, list, 0);
  }
}

enum DisplayType {
  WithName(name:String);
  WithX(x:Int);
  WithY(y:Int);
  WithXY(x:Int, y:Int);
  WithShow(show:Bool);
  
  Table(w:Int, cellW:Int, cellH:Int, ch:Array<DisplayType>);
  Center(w:Int, h:Int, ch:Array<DisplayType>);
  Clip(w:Int, h:Int, ch:Array<DisplayType>);
  
  Panel(bmp:Bitmap, ch:Array<DisplayType>);
  SolidPanel(colour:Colour, w:Int, h:Int, ch:Array<DisplayType>);
  BoxPanel(bmp:Bitmap, cut1:Point2DI, cut2:Point2DI, w:Int, h:Int, ch:Array<DisplayType>);
  Button(bmp:Bitmap, bmpOver:Bitmap, bmpDown:Bitmap, ch:Array<DisplayType>);
  BoxButton(bmp:Bitmap, bmpOver:Bitmap, bmpDown:Bitmap, cut1:Point2DI, cut2:Point2DI, w:Int, h:Int, ch:Array<DisplayType>);
}
