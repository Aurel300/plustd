package sk.thenet.stream;

import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.ds.HashMap;
import haxe.ds.ObjectMap;
import haxe.ds.WeakMap;
import haxe.ds.EnumValueMap;

/**
##Stream collectors##

This class defines some common collector algorithms.

```haxe
// create a Iterator<Int> from an array
var intStream = [1, 2, 3].streamArray();

// create a Stream<Float> with a map function
var floatStream = intStream.map(function(a) return a + .5);

// collect the stream into an array
var floatArray = floatStream.collect(Collectors.toArray());
```

Or, using the `FluentStream` syntax:

```haxe
// create a Iterator<Int> from an array
var intStream = [1, 2, 3].streamArray();

// create a Stream<Float> with a map function
var floatStream = intStream >> (function(a) return a + .5);

// collect the stream into an array
var floatArray = floatStream << (Collectors.toArray());
```
 */
class Collectors {
  /**
Creates a collector which will transform the stream into an array.
   */
  public static inline function toArray<T>():Collector<T, Array<T>> {
    return new CollectorToArray<T>();
  }
  
  /**
Creates a collector which will transform the stream into a string map. The keys
of the map are determined using the `keyFunc`, the values using the `valueFunc`.

```haxe
    var map = [1, 2, 3].streamArray()
      .collect(Collectors.toStringMap(
          function(a) return "number " + a,
          function(a) return a + .5
        ));
    // this produces:
    map = [
        "number 1" => 1.5,
        "number 2" => 2.5,
        "number 3" => 3.5
      ]
```
   */
  public static function toStringMap<T, U>(
    keyFunc:T->String, valueFunc:T->U
  ):Collector<T, Map<String, U>> {
    return new CollectorToMap<T, String, U>(
        keyFunc, valueFunc, function() return new StringMap<U>()
      );
  }
  
  /**
Creates a collector which will transform the stream into an int map. The keys
of the map are determined using the `keyFunc`, the values using the `valueFunc`.

```haxe
    var squares = (1...6)
      .collect(Collectors.toIntMap(
          function(a) return a,
          function(a) return a * a
        ));
    // this produces:
    squares = [
        1 => 1,
        2 => 4,
        3 => 9,
        4 => 16,
        5 => 25
      ]
```
   */
  public static function toIntMap<T, U>(
    kf:T->Int, vf:T->U
  ):Collector<T, Map<Int, U>> {
    return new CollectorToMap<T, Int, U>(
        kf, vf, function() return new IntMap<U>()
      );
  }
}

private class CollectorToArray<T> implements Collector<T, Array<T>> {
  public function new() {}
  
  public function collect(s:Iterator<T>):Array<T> {
    return [ for (e in s) e ];
  }
}

private class CollectorToMap<T, U, V> implements Collector<T, Map<U, V>> {
  private var keyFunc:T->U;
  private var valueFunc:T->V;
  private var mapFunc:Void->Map<U, V>;
  
  public function new(keyFunc:T->U, valueFunc:T->V, mapFunc:Void->Map<U, V>) {
    this.keyFunc = keyFunc;
    this.valueFunc = valueFunc;
    this.mapFunc = mapFunc;
  }
  
  public function collect(s:Iterator<T>):Map<U, V> {
    var ret = mapFunc();
    for (e in s) {
      ret.set(keyFunc(e), valueFunc(e));
    }
    return ret;
  }
}
