package sk.thenet.anim;

import sk.thenet.FM;

/**
##Phaser function##

A phaser function, used for cyclic timers, e.g. walk cycles. The function
`get()` can is written as:

```haxe
    FM.floor(phase / scale) * multiply
```

Where `phase` increases by `speed` with every call to `tick()`, and is kept
within modulo `mod`. If no modulo is needed, set `mod` to `0`.
 */
class Phaser {
  public var phase   :Int;
  public var mod     :Int;
  public var scale   :Int;
  public var multiply:Int;
  public var speed   :Int;
  
  public function new(
     ?mod:Int = 0, ?scale:Int = 1
    ,?multiply:Int = 1, ?speed:Int = 1, ?phase:Int = 0
  ) {
    this.phase    = phase;
    this.mod      = mod;
    this.scale    = scale;
    this.multiply = multiply;
    this.speed    = speed;
  }
  
  public function reset():Void {
    phase = 0;
  }
  
  public function tick():Void {
    phase += (speed >= 0 ? speed : mod + speed);
    if (mod != 0) {
      phase %= mod;
    }
  }
  
  public function get(?tickAfter:Bool = false):Int {
    var ret = FM.floor(phase / scale) * multiply;
    if (tickAfter) {
      tick();
    }
    return ret;
  }
}
