package sk.thenet.stream.prng;

import sk.thenet.stream.Stream;

/**
##PRNG - XOR shift###

Pseudo-random number generator based on XOR shifting.

This generator has a period of `2^128 - 1` and it passes the diehard tests.

Use with `Generator` for methods to obtain various data types.
 */
class XORShift {
  /**
The seed used for this sequence. It is not updated when the state changes.

Changing the seed reseeds the generator (and thus changes the sequence).
   */
  public var seed(default, set):UInt;
  private inline function set_seed(seed:UInt):UInt {
    s = seed;
    x = seed << 1;
    y = seed << 2;
    z = seed << 3;
    return this.seed = seed;
  }
  
  private var x:UInt;
  private var y:UInt;
  private var z:UInt;
  private var s:UInt;
  
  /**
Creates a generator seeded with the given `seed`.

`seed` must be non-zero.
   */
  public function new(seed:UInt) {
    this.set_seed(seed);
  }
  
  public function hasNext():Bool {
    return true;
  }
  
  public function next():UInt {
    var t = x;
    t ^= t << 11;
    t ^= t >> 8;
    x = y;
    y = z;
    z = s;
    s ^= s >> 19;
    s ^= t;
    return s;
  }
}
