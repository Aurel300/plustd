package sk.thenet.ds;

/**
 * A generic 2-tuple.
 */
class Pair<T, U> {
  public var first:T;
  public var second:U;
  
  public function new(?first:T, ?second:U) {
    this.first  = first;
    this.second = second;
  }
  
  public function clone():Pair<T, U> {
    return new Pair(first, second);
  }
}
