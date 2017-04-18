package sk.thenet.bmp;

/**
##Surface##

This interface represents main surfaces that can be drawn onto.

Implementations of this interface are platform-dependent. To maintain good
performance without having to actually cast classes to this interface, there
is a typedef available - `sk.thenet.bmp.Surface` - which becomes an alias for
the current platform-dependent implementation of `ISurface` at compile time. To
actually create a `Surface`, use `sk.thenet.plat.Platform.initSurface()`.
 */
interface ISurface {
  public var bitmap(default, null):Bitmap;
}
