package sk.thenet.anim;

import haxe.ds.Vector;
import sk.thenet.FM;

/**
##Phase function##

A phaser function, used for cyclic timers, e.g. walk cycles. The function
`get()` can is written as:

```haxe
    FM.floor(map[phase] / scale) * multiply
```

Where `phase` increases by `speed` with every call to `tick()`, and is kept
within modulo `mod`. If the mapping is linear, use `Phaser.linear(mod)`.
 */
class Phaser {
  public static function linear(
    mod:Int, ?scale:Int = 1, ?multiply:Int = 1
  ):Phaser {
    var map = new Vector<Int>(mod);
    for (i in 0...mod) {
      map[i] = i;
    }
    return new Phaser(0, mod, map, scale, multiply, 1);
  }
  
  public var phase   :Int;
  public var mod     :Int;
  public var map     :Vector<Int>;
  public var scale   :Int;
  public var multiply:Int;
  public var speed   :Int;
  
  public function new(
    phase:Int, mod:Int, map:Vector<Int>, scale:Int, multiply:Int, speed:Int
  ) {
    this.phase    = phase;
    this.mod      = mod;
    this.map      = map;
    this.scale    = scale;
    this.multiply = multiply;
    this.speed    = speed;
  }
  
  public function reset():Void {
    phase = 0;
  }
  
  public function tick():Void {
    phase += (speed >= 0 ? speed : mod + speed);
    phase %= mod;
  }
  
  public function get():Int {
    return FM.floor(map[phase] / scale) * multiply;
  }
}
