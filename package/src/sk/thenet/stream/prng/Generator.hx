package sk.thenet.stream.prng;

import haxe.ds.Vector;
import haxe.io.Bytes;
import sk.thenet.stream.Stream;

/**
##PRN Generator##

Pseudo-random number generator wrapper. This class wraps a `Stream<UInt>`
(ideally ones from `sk.thenet.stream.prng`) which generates (pseudo-)random
integers infinitely. It adds methods for obtaining specific kinds of data
types.
 */
@:forward(next)
abstract Generator(Stream<UInt>){
  /**
Creates a generator from the given stream.
   */
  public function new(stream:Stream<UInt>){
    this = stream;
  }
  
  /**
@return An integer between `0` (inclusive) and `max` (exclusive).
   */
  public inline function nextMod(max:UInt):UInt {
    return this.next() % max;
  }
  
  /**
@return A float between `0` (inclusive) and `max` (exclusive).
   */
  public inline function nextFloat(max:Float = 1):Float {
    return (this.next() / 2147483647) * max * .5;
  }
  
  /**
@return A `haxe.io.Bytes` object of `length`, where each byte is set to a
pseudo-random number between `min` (inclusive) and `max` (exclusive). If called
with only one argument, the default values for `min` and `max` generate bytes
without restrictions.
   */
  public inline function nextBytes(
    length:Int, ?min:Int = 0, ?max:Int = 0x100
  ):Bytes {
    var ret = Bytes.alloc(length);
    var range = max - min;
    for (i in 0...length){
      ret.set(i, nextMod(range) + min);
    }
    return ret;
  }
  
  public inline function nextElement<T>(array:Array<T>):T {
    return array[nextMod(array.length)];
  }
}
