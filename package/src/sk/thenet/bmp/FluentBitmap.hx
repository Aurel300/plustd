package sk.thenet.bmp;

import sk.thenet.plat.Bitmap;

/**
##Fluent bitmap##

Fluent bitmaps provide syntactic sugar for working with bitmaps and
manipulators in a functional-programming-like way. `bitmap.fluent` returns a
`FluentBitmap` for that `Bitmap`.

Bitmap manipulators provide two types of operations - extraction and
manipulation. Extractions are accessible via the `>>` operator.

```haxe
    // cut a 20x20 region at (10, 10) from bitmap
    var part = (bitmap.fluent >> (new Cut(10, 10, 20, 20)));
```

Manipulations are accessible via the `<<` operator.

```haxe
    // invert the bitmap
    bitmap.fluent << (new Invert());
```

Multiple operations can be chained:

```haxe
    var invertedGrayscalePart = bitmap.fluent
      >> (new Cut(10, 10, 20, 20)) // cut a 20x20 region at (10, 10) from bitmap
      << (new Invert()) // invert it
      << (new Grayscale()); // make it grayscale
```

@see `sk.thenet.bmp.Bitmap`
@see `sk.thenet.bmp.Manipulator`
 */
abstract FluentBitmap(Bitmap) from Bitmap to Bitmap {
  public inline function new(bitmap:Bitmap){
    this = bitmap;
  }
  
  @:op(A >> B)
  public inline function extract(manipulator:Manipulator):FluentBitmap {
    return new FluentBitmap(manipulator.extract(this));
  }
  
  @:op(A << B)
  public inline function manipulate(manipulator:Manipulator):FluentBitmap {
    manipulator.manipulate(this);
    return new FluentBitmap(this);
  }
}
