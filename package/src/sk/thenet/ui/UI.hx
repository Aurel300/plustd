package sk.thenet.ui;

import haxe.ds.ArraySort;
import sk.thenet.M;
import sk.thenet.bmp.Bitmap;
import sk.thenet.event.Source;
import sk.thenet.plat.Platform;

class UI extends Source {
  public var list:Array<Display>;
  public var displayOver:Display;
  public var displayDown:Display;
  public var cursors:Array<Cursor>;
  public var doubleClick:Int = 0;
  
  private var lmx:Int;
  private var lmy:Int;
  private var names:Map<String, Display>;
  private var lastClickTime:Int = 0;
  private var lastClickDisplay:Display;
  
  public function new(?list:Array<Display>) {
    super();
    this.list = M.denull(list, []);
    cursors = [];
    names = new Map<String, Display>();
    reset();
    update();
  }
  
  public inline function get(id:String):Display {
    return names.get(id);
  }
  
  public function update(?root:Array<Display>):Void {
    function updateSub(list:Array<Display>, prefix:String):Void {
      if (list == null) {
        return;
      }
      for (l in list) {
        if (l.name != null) {
          names.set(prefix + l.name, l);
        }
        updateSub(l.children, prefix + (l.name != null ? l.name + "." : ""));
      }
    }
    updateSub(M.denull(root, list), "");
  }
  
  public function reset():Void {
    lmx = lmy = 0;
    if (displayOver != null) {
      displayOver.mouseOver = false;
      displayOver = null;
    }
    if (displayDown != null) {
      displayDown.mouseDown = false;
      displayDown = null;
    }
  }
  
  public function render(bmp:Bitmap, ?ox:Int = 0, oy:Int = 0):Void {
    if (lastClickTime > 0) {
      lastClickTime--;
      if (lastClickTime == 0) {
        lastClickDisplay = null;
      }
    }
    function renderSub(bmp:Bitmap, list:Array<Display>, ox:Int, oy:Int):Void {
      if (list == null) {
        return;
      }
      for (l in list) {
        if (!l.show) {
          continue;
        }
        var inbound = ox + l.x < bmp.width && ox + l.x + l.w >= 0
            && oy + l.y < bmp.height && oy + l.y + l.h >= 0;
        if (inbound) {
          l.render(bmp, ox + l.x, oy + l.y);
        }
        if (l.clip) {
          if (inbound) {
            if (l.w == l.clipTarget.width && l.h == l.clipTarget.height) {
              l.clipTarget.fill(0);
            } else {
              l.clipTarget = Platform.createBitmap(l.w, l.h, 0);
            }
            renderSub(l.clipTarget, l.children, 0, 0);
            bmp.blitAlpha(l.clipTarget, ox + l.x, oy + l.y);
          }
        } else {
          renderSub(bmp, l.children, ox + l.x, oy + l.y);
        }
      }
    }
    renderSub(bmp, list, ox, oy);
    for (c in cursors) {
      bmp.blitAlpha(c.bitmap, lmx + c.offX, lmy + c.offY);
    }
  }
  
  public function mouseMove(mx:Int, my:Int, ?ox:Int = 0, ?oy:Int = 0):Display {
    if (displayDown != null) {
      fireEvent(new EDisplayDrag(this, displayDown, mx - lmx, my - lmy, mx - displayDown.fullX, my - displayDown.fullY));
    }
    if (displayOver != null) {
      displayOver.mouseOver = false;
    }
    displayOver = mouseAt(mx, my, ox, oy);
    if (displayOver != null) {
      displayOver.mouseOver = true;
    }
    return displayOver;
  }
  
  public function mouseDown(mx:Int, my:Int, ?ox:Int = 0, ?oy:Int = 0):Display {
    if (displayDown != null) {
      displayDown.mouseDown = false;
    }
    displayDown = mouseAt(mx, my, ox, oy);
    if (displayDown != null) {
      displayDown.mouseDown = true;
    }
    return displayDown;
  }
  
  public function mouseUp(mx:Int, my:Int, ?ox:Int = 0, ?oy:Int = 0):Display {
    var d = mouseAt(mx, my, ox, oy);
    if (displayDown != null) {
      if (displayDown == d) {
        if (doubleClick > 0 && lastClickTime > 0 && lastClickDisplay == d) {
          var ev = new EDisplayClick(this, d, mx - ox, my - oy, true);
          d.fireEvent(ev);
          fireEvent(ev);
          lastClickTime = 0;
          lastClickDisplay = null;
        } else {
          var ev = new EDisplayClick(this, d, mx - ox, my - oy);
          d.fireEvent(ev);
          fireEvent(ev);
          lastClickTime = doubleClick;
          lastClickDisplay = d;
        }
      } else if (d != null) {
        var ev = new EDisplayDrop(this, displayDown, d);
        d.fireEvent(ev);
        fireEvent(ev);
      }
      displayDown.mouseDown = false;
      displayDown = null;
    }
    return d;
  }
  
  private function mouseAt(mx:Int, my:Int, ?ox:Int = 0, ?oy:Int = 0):Display {
    lmx = mx;
    lmy = my;
    function mouseAtSub(list:Array<Display>, ox:Int, oy:Int, xmin:Int, ymin:Int, xmax:Int, ymax:Int):Display {
      if (list == null) {
        return null;
      }
      //list.sort(zSort);
      for (li in 0...list.length) {
        var l = list[list.length - li - 1];
        if (!l.show) {
          continue;
        }
        var ret = (if (l.clip) {
            mouseAtSub(
                 l.children, ox + l.x, oy + l.y
                ,FM.maxI(ox + l.x, xmin), FM.maxI(oy + l.y, ymin)
                ,FM.minI(ox + l.x + l.w, xmax), FM.minI(oy + l.y + l.h, ymax)
              );
          } else {
            mouseAtSub(l.children, ox + l.x, oy + l.y, xmin, ymin, xmax, ymax);
          });
        if (ret != null) {
          return ret;
        }
        if (mx >= xmin && mx < xmax && my >= ymin && my < ymax
            && mx >= ox + l.x && mx < ox + l.x + l.w
            && my >= oy + l.y && my < oy + l.y + l.h) {
          return l;
        }
      }
      return null;
    }
    return mouseAtSub(list, ox, oy, ox, oy, 9999, 9999);
  }
  
  private function zSort(a:Display, b:Display):Int {
    return a.z - b.z;
  }
}
