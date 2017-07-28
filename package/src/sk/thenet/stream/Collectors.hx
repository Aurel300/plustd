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
// create a Stream<Int> from an array
var intStream = Stream.ofArray([1, 2, 3]);

// create a Stream<Float> with a map function
var floatStream = intStream.map(function(a) return a + .5);

// collect the stream into an array
var floatArray = floatStream.collect(Collectors.toArray());
// or, equivalently
var floatArray = Collectors.toArray().collect(floatStream);
```

Using `Stream.collect` allows this syntax:

```haxe
    var floatArray = Stream.ofArray([1, 2, 3])
      .map(function(a) return a + .5)
      .collect(Collectors.toArray());
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
    var map = Stream.ofArray([1, 2, 3])
      .collect(Collectors.toStringMap(
          function(a) return "number " + a,
          function(a) return a + .5
        ));
    // this produces:
    map = {
        "number 1" => 1.5,
        "number 2" => 2.5,
        "number 3" => 3.5
      }
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
    var squares = Stream.ofIterator(1...6)
      .collect(Collectors.toIntMap(
          function(a) return a,
          function(a) return a * a
        ));
    // this produces:
    squares = {
        1 => 1,
        2 => 4,
        3 => 9,
        4 => 16,
        5 => 25
      }
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
  
  public function collect(s:Stream<T>):Array<T> {
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
  
  public function collect(s:Stream<T>):Map<U, V> {
    var ret = mapFunc();
    for (e in s) {
      ret.set(keyFunc(e), valueFunc(e));
    }
    return ret;
  }
}

/*
// Maps in Haxe are too messy

private class CollectorToMapUndef<T, U, V> implements Collector<T, Map<U, V>> {
  public var key_function:T->U;
  public var value_function:T->V;
  
  public function new(nkf:T->U, nvf:T->V) {
    key_function = nkf;
    value_function = nvf;
  }
  
  public function collect(s:Stream<T>):Map<U, V> {
    var ret = new Map<U, V>();
    for (e in s) {
      ret.set(key_function(e), value_function(e));
    }
    return ret;
  }
}

private abstract CollectorToMap<T, U, V>(Collector<T, Map<U, V>>) {
  @:to static inline function toStringMap<T, U:String, V>(t:CollectorToMapUndef<T, U, V>):Collector<T, StringMap<V>> {
    return new CollectorToStringMap<T, V>(t.key_function, t.value_function);
  }
  
  @:from static inline function fromStringMap<T, U:String, V>(t:Collector<T, StringMap<V>>):CollectorToMap<T, U, V> {
    return cast t;
  }
  
  public inline function new(nkf:T->U, nvf:T->V) {
    this = new CollectorToMapUndef<T, U, V>(nkf, nvf);
  }
}

private class CollectorToStringMap<T, V> implements Collector<T, StringMap<V>> {
  private var key_function:T->String;
  private var value_function:T->V;
  
  public function new(nkf:T->String, nvf:T->V) {
    key_function = nkf;
    value_function = nvf;
  }
}

/*
private class CollectorToMap<T, U, V> implements Collector<T, Map<U, V>> {
  private var key_function:T->U;
  private var value_function:T->V;
  
  public function new(nkf:T->U, nvf:T->V) {
    key_function = nkf;
    value_function = nvf;
  }
  
  public function collect(s:Stream<T>):Map<U, V> {
    var ret = new Map<U, V>();
    for (e in s) {
      ret.set(key_function(e), value_function(e));
    }
    return ret;
  }
}
*/