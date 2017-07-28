package sk.thenet.stream;

import haxe.ds.Vector;

/**
##Stream##

Simple class to aid functional programming. Streams are objects which can
generate elements. Generally, they are evaluated lazily. They can be iterated
using for loops.

Streams can be created from arrays, lists, vectors, and iterators using the
static `from*` methods. There are also methods for creating infinite streams
from generating functions.

Any operation applied to a stream prevents the stream from being used again.
Some operations produce another stream (stream operations), some do not
(terminal operations).

####Stream operations####

Stream operations produce another stream. Note that these may not be evaluated
immediately (or at all) due to lazy evaluation. To ensure evaluation, use a
terminal operation.

List of stream operations supported:

 - `Stream.filter`
 - `Stream.map`
 - `Stream.passThrough`
 - `Stream.skip`
 - `Stream.take`

####Terminal operations####

Terminal operations are applied to all elements of the stream.

While terminal operations may be applied to infinite streams, they may never
complete. Use with caution.

List of terminal operations supported:

 - `Stream.collect`
 - `Stream.forEach`
 */
class Stream<T> {
  /**
Generates a stream from an `Array<T>`. The elements are streamed in the array
order.
   */
  public static function ofArray<T>(array:Array<T>):Stream<T> {
    var it = array.iterator();
    return new Stream<T>(it.hasNext, it.next);
  }
  
  /**
Generates a stream from a `List<T>`. The elements are streamed in the list
order.
   */
  public static function ofList<T>(list:List<T>):Stream<T> {
    var it = list.iterator();
    return new Stream<T>(it.hasNext, it.next);
  }
  
  /**
Generates a stream from a `haxe.ds.Vector<T>`. The elements are streamed in the
vector order.
   */
  public static function ofVector<T>(vector:Vector<T>):Stream<T> {
    var it = 0...vector.length;
    return new Stream<T>(it.hasNext, function() return vector[it.next()]);
  }
  
  private static function always():Bool {
    return true;
  }
  
  /**
Generates an infinite stream from a generating function.
   */
  public static function ofGenerator<T>(generatingFunc:Void->T):Stream<T> {
    return new Stream<T>(always, generatingFunc);
  }
  
  /**
Generates a stream from an iterator.
   */
  public static function ofIterator<T>(iterator:Iterator<T>):Stream<T> {
    return new Stream<T>(iterator.hasNext, iterator.next);
  }
  
  /**
Generates an infinite stream from a starting value (seed) and a unary function
which will be repeatedly applied to it. Its result is then used as the seed for
the next iteration, etc.

The seed is the first value produced by this stream, without being modified by
the iteration function. The iteration function is called at every element, but
its value is returned in the next iteration.
   */
  public static function ofSeedIteration<T>(
    seed:T, iterationFunc:T->T
  ):Stream<T> {
    var current:T = seed;
    return new Stream<T>(always, function() {
        var old:T = current;
        current = iterationFunc(current);
        return old;
      });
  }
  
  public var fluent(get, never):FluentStream<T>;
  
  private inline function get_fluent():FluentStream<T> {
    return new FluentStream(this);
  }
  
  private var continueFunc:Void->Bool;
  private var streamFunc:Void->T;
  private var operated:Bool;
  
  /**
Creates a new Stream given a continue function and a stream function.

The continue function returns a boolean - `true` iff the stream still has
elements. This is equivalent to `hasNext` in iterators. Infinite streams will
always return `true` in their continue function.

The stream function returns the actual elements of the stream. This is
equivalent to `next` in iterators.
   */
  private function new(continueFunc:Void->Bool, streamFunc:Void->T) {
    this.continueFunc = continueFunc;
    this.streamFunc = streamFunc;
    operated = false;
  }
  
  /**
@return `true` iff there are more elements in the stream.
   */
  public inline function hasNext():Bool {
    return continueFunc();
  }
  
  /**
@return The next element in the stream, if available.
   */
  public inline function next():T {
    return streamFunc();
  }
  
  // checks if stream was used, throws if so
  private inline function checkOperated():Void {
    if (operated) throw "stream used";
    operated = true;
  }
  
  /**
Applies a mapping function to each element in the stream. This produces another
stream, whose type does not have to be the same as that of the original stream.

```haxe
var floats = Stream.ofArray([1.5, 2.5, 3.5]);
var ints = floats.map(FM.floor);
ints.forEach(function(a) trace(a)); // 1, 2, 3
```

This is a stream operation.
   */
  public function map<U>(func:T->U):Stream<U> {
    checkOperated();
    return new Stream<U>(continueFunc, function() return func(streamFunc()));
  }
  
  /**
Applies a filter function to the stream. This produces another stream,
consisting only of elements for which the filter function returned true.

Applying this function to an infinite stream where no element satisfies the
filter function will cause an infinite loop - use with caution.

This is a stream operation.
   */
  public function filter(func:T->Bool):Stream<T> {
    checkOperated();
    var fel:Bool = false;
    var nel:T = null;
    return new Stream<T>(function() {
        fel = false;
        while (continueFunc()) {
          nel = streamFunc();
          if (func(nel)) {
            fel = true;
            break;
          }
        }
        return fel;
      }, function() return nel);
  }
  
  /**
Skips `n` elements in the stream, then returns a stream consisting of the rest.

This is a stream operation.
   */
  public function skip(n:Int):Stream<T> {
    checkOperated();
    var i:Int = 0;
    while (i < n && continueFunc()) {
      streamFunc();
      i++;
    }
    return new Stream<T>(continueFunc, streamFunc);
  }
  
  /**
Returns a stream consisting of the first `n` elements of the original stream.

This is a stream operation.
   */
  public function take(n:Int):Stream<T> {
    checkOperated();
    var i:Int = 0;
    return new Stream<T>(function() {
        if (!continueFunc()) return false;
        return i < n;
      }, function() {
        i++;
        return streamFunc();
      });
  }
  
  /**
Applies a function to each element as it passes through the stream. This is
similar to `Stream.forEach`, but returns a stream with the original elements.

Please note the pass through function will not be evaluated until the stream
is forced to evaluate, e.g. using terminal operations.

This is a stream operation.
  */
  public function passThrough(func:T->Void):Stream<T> {
    return new Stream<T>(continueFunc, function() {
        var el = streamFunc();
        func(el);
        return el;
      });
  }
  
  /**
Applies a `Collector` to this stream.

This is a terminal operation.
   */
  public function collect<U>(c:Collector<T, U>):U {
    checkOperated();
    return c.collect(this);
  }
  
  /**
Applies a function to each element of this stream.

This is a terminal operation.
   */
  public function forEach(func:T->Void):Void {
    checkOperated();
    for (e in this) {
      func(e);
    }
  }
}
