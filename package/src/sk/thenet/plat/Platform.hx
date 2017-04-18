package sk.thenet.plat;

/**
##Platform##

This is a `typedef` aliased to the current platform. The class provides methods
to test if the platform supports various features, and also methods to execute
platform-dependent functionality. This method allows for the rest of the library
to be platform-agnostic, while maintaining good performance (inline methods
can actually be inlined).

Any class which is defined as the current platform will have the same public
static methods as `sk.thenet.plat.dummy.Platform`. The dummy platform also
serves as the API documentation for the static methods provided by platforms.

`Platform` also provides a field `source` of type `sk.thenet.event.Source`,
which fires native events, such as mouse movement, clicks, ticks, etc.
These have to be initialised with the `init*` methods beforehand. Similarly for
`keyboard` and `mouse`.

####Platforms provided in plustd####

Currently, plustd provides these `Platform` subclasses:

 - `sk.thenet.plat.cppsdl.Platform` - C++ / SDL / OpenGL (TODO)
 - `sk.thenet.plat.flash.Platform` - Adobe Flash
 - `sk.thenet.plat.jsca.Platform` - Javascript / Canvas (TODO)
 - `sk.thenet.plat.jsgl.Platform` - Javascript / WebGL (TODO, enabled
when `-D js-webgl`)
 - `sk.thenet.plat.neko.Platform` - Neko VM

####Defining custom platforms####

It is also possible to override the current platform and provide code to extend
or modify the functionality of any givne platform. To do this, a file has to be
provided in the classpath `sk.thenet.plat.Platform`, which will contain:

```haxe
    typedef Platform = ModifiedPlatform;
```

It is important that this file comes in the classpaths after the haxelib for
this library, thus overriding the `typedef Platform`. In the above example, care
has to be taken to ensure `ModifiedPlatform` has the same static methods as
`sk.thenet.plat.dummy.Platform`. To make this assertion at compile time, extend
the `PlatformBase` base class, which will automatically check for the necessary
fields (using an autobuild macro) and add defaults if any are missing.

```haxe
    class ModifiedPlatform extends sk.thenet.plat.PlatformBase {
      // custom code here
    }
```

Similar steps have to be taken for `typedef`s:

 - `Bitmap`
 - `Output`
 - `Socket`
 - `Surface`
 */
typedef Platform =
#if cpp
    sk.thenet.plat.cppsdl.Platform
#elseif flash
    sk.thenet.plat.flash.Platform
#elseif js
    sk.thenet.plat.js.canvas.Platform
#elseif neko
    sk.thenet.plat.neko.Platform
#else
    sk.thenet.plat.dummy.Platform
#end
  ;