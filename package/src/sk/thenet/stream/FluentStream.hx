package sk.thenet.stream;

using sk.thenet.stream.Stream;

/**
##Fluent stream##

Fluent streams provide syntactic sugar for working with streams / iterators.
`iter.fluent()` returns a `FluentStream<T>` for that `Iterator<T>` (when using
`Stream` as a static extension).

Operations in the `Stream` class return `FluentStream<T>`, not `Iterator<T>`,
hence using `fluent()` is unnecessary. One exception is when using an existing
iterator, for example:

```haxe
    (0...5).fluent();
```

Three operators are overloaded for use with fluent sreams - `>>>`, `>>`, and
`<<`.

####`<<` - terminal operation####

(See `sk.thenet.stream.Stream` for stream / terminal operations explanation.)

`<<` applies a terminal operation, which can be either a collector or a forEach
function.

```haxe
    [1, 2, 3].streamArray().fluent() << (function(a) trace(a));
    // 1, 2, 3
```

```haxe
    var arr = [1, 2, 3].streamArray().fluent() << (Collectors.toArray());
    trace(arr); // [1, 2, 3]
```

####`>>` - mapping####

`>>` applies a mapping function to a stream and returns another stream.

```haxe
    var squares = (1...6).fluent()
      >> (function(a) return a * a)
      << (function(a) trace(a));
    // 1, 4, 9, 16, 25
```

####`>>>` - pass through####

`>>>` applies a pass through function. This needs to be separate from `>>`
because `>>` expects a function `T->U` to map a `Iterator<T>` to `Iterator<U>`.
`Void` is a perfectly valid type parameter, so Haxe has no way of knowing
whether a map to `Void` is meant to be a pass through.

```haxe
    (1...4).fluent()
      >>> (function(a) trace(a))
      >> (function(a) return a * a)
      << (function(a) trace(a));
    // the traces from the pass through and the forEach alternate:
    //   1
    //   1
    //   2
    //   4
    //   3
    //   9
```

@see `sk.thenet.stream.Stream`
 */
abstract FluentStream<T>(Iterator<T>) from Iterator<T> to Iterator<T> {
  public inline function new(stream:Iterator<T>) {
    this = stream;
  }
  
  /**
Applies a mapping function, returns the resulting fluent stream.
   */
  @:op(A >> B)
  public inline function map<U>(func:T->U):FluentStream<U> {
    return new FluentStream(this.map(func));
  }
  
  /**
Applies a pass through, returns the resulting fluent stream.
   */
  @:op(A >>> B)
  public inline function passThrough(func:T->Void):FluentStream<T> {
    return new FluentStream(this.passThrough(func));
  }
  
  /**
Applies a function to each element.
   */
  @:op(A << B)
  public inline function forEach(func:T->Void):Void {
    this.forEach(func);
  }
  
  /**
Applies a collector to the stream and returns the collected type.
   */
  @:op(A << B)
  public inline function collect<U>(collector:Collector<T, U>):U {
    return this.collect(collector);
  }
}
