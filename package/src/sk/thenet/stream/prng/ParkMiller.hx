package sk.thenet.stream.prng;

import sk.thenet.stream.Stream;

/**
##PRNG - Park-Miller###

Pseudo-random number generator based on the Park-Miller function (Lehmer
random number generator).

Use with `Generator` for methods to obtain various data types.
 */
class ParkMiller {
  private static inline var PARAM:UInt = 48271;
  
  /**
The seed used for this sequence. It is not updated when the state changes.

Changing the seed reseeds the generator (and thus changes the sequence).
   */
  public var seed(default, set):UInt;
  private inline function set_seed(seed:UInt):UInt {
    s = seed;
    return this.seed = seed;
  }
  
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
    return s = (s * PARAM); // % 2147483647;
  }
}
