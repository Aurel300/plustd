package sk.thenet.anim;

import haxe.ds.Vector;
import sk.thenet.FM;

/**
##Mapped phaser function##

A mapped phaser function. Unlike `Phaser`, this function maps its value via the
provided `map` vector. So `get()` can is written as:

```haxe
    FM.floor(map[phase] / scale) * multiply
```
 */
class MappedPhaser extends Phaser {
  /**
Creates a mapped phaser where the mapping is an identity mapping (i.e
`map[x] == x`). Use this to quickly generate a mapping which only has a few
modifications from the identity.
   */
  public static function linear(
    mod:Int, ?scale:Int = 1, ?multiply:Int = 1
  ):Phaser {
    var map = new Vector<Int>(mod);
    for (i in 0...mod) {
      map[i] = i;
    }
    return new MappedPhaser(map, mod, scale, multiply, 1, 0);
  }
  
  public var map:Vector<Int>;
  
  public function new(
     map:Vector<Int>, ?mod:Int = 0, ?scale:Int = 1
    ,?multiply:Int = 1, ?speed:Int = 1, ?phase:Int = 0
  ) {
    super(mod, scale, multiply, speed, phase);
    this.map = map;
  }
  
  override public function get(?tickAfter:Bool = false):Int {
    var ret = FM.floor(map[phase] / scale) * multiply;
    if (tickAfter) {
      tick();
    }
    return ret;
  }
}
