package sk.thenet.ui;

import sk.thenet.bmp.Bitmap;
import sk.thenet.event.Source;

class UI extends Source {
  public var list:Array<Display>;
  public var names:Map<String, Display>;
  public var lmx:Int;
  public var lmy:Int;
  public var displayOver:Display;
  public var displayDown:Display;
  
  public function new(?list:Array<Display>) {
    super();
    this.list = (list != null ? list : []);
    names = new Map<String, Display>();
    update();
  }
  
  public inline function get(id:String):Display {
    return names.get(id);
  }
  
  private function zSort(a:Display, b:Display):Int {
    return a.z - b.z;
  }
  
  public function update():Void {
    function updateSub(list:Array<Display>, prefix:String):Void {
      if (list == null) {
        return;
      }
      list.sort(zSort);
      for (l in list) {
        if (l.name != null) {
          names.set(prefix + l.name, l);
        }
        updateSub(l.children, l.name + ".");
      }
    }
    updateSub(list, "");
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
    function renderSub(list:Array<Display>, ox:Int, oy:Int):Void {
      if (list == null) {
        return;
      }
      list.sort(zSort);
      for (l in list) {
        l.render(bmp, ox + l.x, oy + l.y);
        renderSub(l.children, ox + l.x, oy + l.y);
      }
    }
    renderSub(list, ox, oy);
  }
  
  private function mouseAt(mx:Int, my:Int, ?ox:Int = 0, ?oy:Int = 0):Display {
    lmx = mx;
    lmy = my;
    function mouseAtSub(list:Array<Display>, ox:Int, oy:Int):Display {
      if (list == null) {
        return null;
      }
      list.sort(zSort);
      for (l in list) {
        var ret = mouseAtSub(l.children, ox + l.x, oy + l.y);
        if (ret != null) {
          return ret;
        }
        if (mx >= ox + l.x && mx < ox + l.x + l.w
            && my >= oy + l.y && my < oy + l.y + l.h) {
          return l;
        }
      }
      return null;
    }
    return mouseAtSub(list, ox, oy);
  }
  
  public function mouseMove(mx:Int, my:Int, ?ox:Int = 0, oy:Int = 0):Display {
    if (displayOver != null) {
      displayOver.mouseOver = false;
    }
    displayOver = mouseAt(mx, my, ox, oy);
    if (displayOver != null) {
      displayOver.mouseOver = true;
    }
    return displayOver;
  }
  
  public function mouseDown(mx:Int, my:Int, ?ox:Int = 0, oy:Int = 0):Display {
    if (displayDown != null) {
      displayDown.mouseDown = false;
    }
    displayDown = mouseAt(mx, my, ox, oy);
    if (displayDown != null) {
      displayDown.mouseDown = true;
    }
    return displayDown;
  }
  
  public function mouseUp(mx:Int, my:Int, ?ox:Int = 0, oy:Int = 0):Display {
    var d = mouseAt(mx, my, ox, oy);
    if (displayDown != null) {
      if (displayDown == d) {
        fireEvent(new EDisplayClick(this, d));
      }
      displayDown.mouseDown = false;
      displayDown = null;
    }
    return d;
  }
}
