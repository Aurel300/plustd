package sk.thenet.stream;

import haxe.ds.Vector;

/**
##Stream##

Simple tools to aid functional programming with streams. Streams / iterators
are objects which can generate elements and tell when they are exhausted.
Generally, they are evaluated lazily. They can be iterated using for loops.

The intended usage for this class is to use it as static extension:

```haxe
    using sk.thenet.stream.Stream;
```

Then to create a stream from an array:

```haxe
    [1, 2, 3].streamArray();
```

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
 - `Stream.eager`
 - `Stream.forEach`
 */
class Stream {
  /**
Generates a stream from an `Array<T>`. The elements are streamed in the array
order.
   */
  public static inline function streamArray<T>(array:Array<T>):FluentStream<T> {
    return array.iterator();
  }
  
  /**
Generates a stream from a `List<T>`. The elements are streamed in the list
order.
   */
  public static inline function streamList<T>(list:List<T>):FluentStream<T> {
    return list.iterator();
  }
  
  /**
Generates a stream from a `haxe.ds.Vector<T>`. The elements are streamed in the
vector order.
   */
  public static function streamVector<T>(vector:Vector<T>):FluentStream<T> {
    var it = 0...vector.length;
    return {hasNext: it.hasNext, next: function() return vector[it.next()]};
  }
  
  private static function always():Bool {
    return true;
  }
  
  /**
Generates an infinite stream from a generating function.
   */
  public static function streamFunction<T>(func:Void->T):FluentStream<T> {
    return {hasNext: always, next: func};
  }
  
  /**
Generates an infinite stream from a starting value (seed) and a unary function
which will be repeatedly applied to it. Its result is then used as the seed for
the next iteration, etc.

The seed is the first value produced by this stream, without being modified by
the iteration function. The iteration function is called at every element, but
its value is returned in the next iteration.
   */
  public static function streamSeed<T>(seed:T, func:T->T):FluentStream<T> {
    var current = seed;
    return {hasNext: always, next: function() {
        var old = current;
        current = func(current);
        return old;
      }};
  }
  
  public static inline function fluent<T>(stream:Iterator<T>):FluentStream<T> {
    return new FluentStream(stream);
  }
  
  /**
Applies a mapping function to each element in the stream. This produces another
stream, whose type does not have to be the same as that of the original stream.

```haxe
var floats = [1.5, 2.5, 3.5].streamArray();
var ints = floats.map(FM.floor);
ints.forEach(function(a) trace(a)); // 1, 2, 3
```

This is a stream operation.
   */
  public static function map<T, U>(stream:Iterator<T>, func:T->U):FluentStream<U> {
    return {hasNext: stream.hasNext, next: function() return func(stream.next())};
  }
  
  /**
Applies a filter function to the stream. This produces another stream,
consisting only of elements for which the filter function returned true.

Applying this function to an infinite stream where no element satisfies the
filter function will cause an infinite loop - use with caution.

This is a stream operation.
   */
  public static function filter<T>(stream:Iterator<T>, func:T->Bool):FluentStream<T> {
    var nel:T = null;
    return {hasNext: function() {
        while (stream.hasNext()) {
          nel = stream.next();
          if (func(nel)) {
            return true;
          }
        }
        return false;
      }, next: function() return nel};
  }
  
  /**
Skips `n` elements in the stream, then returns a stream consisting of the rest.

This is a stream operation.
   */
  public static function skip<T>(stream:Iterator<T>, n:Int):FluentStream<T> {
    for (i in 0...n) if (stream.hasNext()) {
      stream.next();
    }
    return stream;
  }
  
  /**
Returns a stream consisting of the first `n` elements of the original stream.

This is a stream operation.
   */
  public static function take<T>(stream:Iterator<T>, n:Int):FluentStream<T> {
    var i:Int = 0;
    return {hasNext: function() {
        return stream.hasNext() && i < n;
      }, next: function() {
        i++;
        return stream.next();
      }};
  }
  
  /**
Applies a function to each element as it passes through the stream. This is
similar to `Stream.forEach`, but returns a stream with the original elements.

Please note the pass through function will not be evaluated until the stream
is forced to evaluate, e.g. using terminal operations.

This is a stream operation.
  */
  public static function passThrough<T>(stream:Iterator<T>, func:T->Void):FluentStream<T> {
    return {hasNext: stream.hasNext, next: function() {
        var el = stream.next();
        func(el);
        return el;
      }};
  }
  
  /**
Applies a `Collector` to the given stream.

This is a terminal operation.
   */
  public static function collect<T, U>(stream:Iterator<T>, c:Collector<T, U>):U {
    return c.collect(stream);
  }
  
  /**
Forces the given stream to generate all of its elements.

This is a terminal operation.
   */
  public static function eager<T>(stream:Iterator<T>):Void {
    for (e in stream) {}
  }
  
  /**
Applies a function to each element of the given stream.

This is a terminal operation.
   */
  public static function forEach<T>(stream:Iterator<T>, func:T->Void):Void {
    for (e in stream) {
      func(e);
    }
  }
  
  /**
Lazily flattens an array of streams.
   */
  public static function flatten<T>(streams:Array<Iterator<T>>):Iterator<T> {
    return {hasNext: function() {
        for (iter in streams) {
          if (iter.hasNext()) {
            return true;
          }
        }
        return false;
      }, next: function() {
        while (!streams[0].hasNext()) {
          streams.shift();
        }
        return streams[0].next();
      }};
  }
  
  /**
Adds a value at the end of the given stream.
   */
  public static function push<T>(stream:Iterator<T>, add:T):Iterator<T> {
    var added = false;
    return {
         hasNext: function () return (stream.hasNext() || !added)
        ,next: function () {
            if (stream.hasNext()) {
              return stream.next();
            }
            added = true;
            return add;
          }
      };
  }
  
  /**
Adds a value at the beginning of the given stream.
   */
  public static function unshift<T>(stream:Iterator<T>, add:T):Iterator<T> {
    var added = false;
    return {
         hasNext: function () return (stream.hasNext() || !added)
        ,next: function () {
            if (!added) {
              added = true;
              return add;
            }
            return stream.next();
          }
      };
  }
  
  public static inline function id<T>(val:T):T {
    return val;
  }
  
  public static function avg<T, U:Float>(stream:Iterator<T>, func:T->U):Float {
    var sum:U = (cast 0:U);
    var count = 0;
    for (e in stream) {
      sum += func(e);
      count++;
    }
    return sum / count;
  }
  
  public static function min<T, U:Float>(stream:Iterator<T>, func:T->U):U {
    var min = func(stream.next());
    for (e in stream) {
      var val = func(e);
      if (val < min) {
        min = val;
      }
    }
    return min;
  }
  
  public static function minEl<T, U:Float>(stream:Iterator<T>, func:T->U):T {
    var minEl = stream.next();
    var min = func(minEl);
    for (e in stream) {
      var val = func(e);
      if (val < min) {
        minEl = e;
        min = val;
      }
    }
    return minEl;
  }
  
  public static function minIdx<T, U:Float>(stream:Iterator<T>, func:T->U):Int {
    var minIdx = 0;
    var min = func(stream.next());
    var idx = 1;
    for (e in stream) {
      var val = func(e);
      if (val < min) {
        minIdx = idx;
        min = val;
      }
      idx++;
    }
    return minIdx;
  }
  
  public static function max<T, U:Float>(stream:Iterator<T>, func:T->U):U {
    var max = func(stream.next());
    for (e in stream) {
      var val = func(e);
      if (val > max) {
        max = val;
      }
    }
    return max;
  }
  
  public static function sum<T, U:Float>(stream:Iterator<T>, func:T->U):U {
    var sum:U = (cast 0:U);
    for (e in stream) {
      sum += func(e);
    }
    return sum;
  }
}
