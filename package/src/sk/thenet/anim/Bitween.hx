package sk.thenet.anim;

class Bitween {
  public var state:BitweenValue;
  public var length:Int;
  
  public var isOn(get, never):Bool;
  private inline function get_isOn():Bool {
    return state == On;
  }
  
  public var isOff(get, never):Bool;
  private inline function get_isOff():Bool {
    return state == Off;
  }
  
  public var value(get, never):Int;
  private inline function get_value():Int {
    return (switch (state) {
        case Off: 0;
        case ToOn(val) | ToOff(val): val;
        case On: length;
      });
  }
  
  public var valueF(get, never):Float;
  private inline function get_valueF():Float {
    return value / length;
  }
  
  public function new(?length:Int = 30) {
    state = Off;
    this.length = length;
  }
  
  public inline function tick():Void {
    state = (switch (state) {
        case Off: Off;
        case ToOn(val): val + 1 >= length ? On : ToOn(val + 1);
        case On: On;
        case ToOff(val): val - 1 <= 0 ? Off : ToOff(val - 1);
      });
  }
  
  public inline function setTo(on:Bool, ?instant:Bool = false):Void {
    if (instant) {
      state = (on ? On : Off);
    } else if (on) {
      state = (switch (state) {
          case Off: ToOn(0);
          case ToOn(val) | ToOff(val): ToOn(val);
          case On: On;
        });
    } else {
      state = (switch (state) {
          case Off: Off;
          case ToOn(val) | ToOff(val): ToOff(val);
          case On: ToOff(length);
        });
    }
  }
  
  public inline function toggle():Void {
    state = (switch (state) {
        case Off: ToOn(0);
        case ToOn(val): ToOff(val);
        case On: ToOff(length);
        case ToOff(val): ToOn(val);
      });
  }
}

enum BitweenValue {
  Off;
  ToOn(val:Int);
  On;
  ToOff(val:Int);
}
