package sk.thenet.stream.prng;

import sk.thenet.stream.Stream;

/**
##PRNG - Park-Miller###

Pseudo-random number generator based on the Park-Miller function (Lehmer
random number generator).

Use with `Generator` for methods to obtain various data types.
 */
class ParkMiller extends Stream<UInt> {
  /**
The seed used for this sequence. It is not updated when the state changes.

Changing the seed reseeds the generator (and thus changes the sequence).
   */
  public var seed(default, set):UInt;
  
  private var s:UInt;
  private var g:UInt = 48271;
  
  /**
Creates a generator seeded with the given `seed`.

`seed` must be non-zero.
   */
  public function new(seed:UInt) {
    super(Stream.always, function() return this.nextNumber());
    this.set_seed(seed);
  }
  
  private inline function set_seed(seed:UInt):UInt {
    s = seed;
    return this.seed = seed;
  }
  
  private inline function nextNumber():UInt {
    return s = (s * g) % 2147483647;
  }
}
