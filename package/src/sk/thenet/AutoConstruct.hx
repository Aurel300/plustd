package sk.thenet;

/**
##Auto-construct##

This is a virtual interface that will automatically add a constructor to the
classes that implement it. The constructor will have the same number of
arguments as there are member variables in the class. The arguments will be
required and will be in the same order as the variable declarations.

If there is a constructor already present, this will combine it with the
variable initialisation code. The variable initialisation will always come
first.

Mostly identical to the Haxe github gist by puffnfresh and deltaluca:
https://gist.github.com/puffnfresh/5314836

```haxe
    class Example implements sk.thenet.AutoConstruct {
      public var x:Int;
      public var y:String;
    }
```

Translates to:

```haxe
    class Example {
      public var x:Int;
      public var y:String;
      
      public function new(x:Int, y:String) {
        this.x = x;
        this.y = y;
      }
    }
```
 */
@:remove
@:autoBuild(sk.thenet.M.autoConstruct())
extern interface AutoConstruct {}
