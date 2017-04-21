package sk.thenet;

import haxe.ds.Vector;

/**
##Utilities##

Utility class with some shortcut methods.
 */
class U {
  public static inline function callNotNull<T, U>(func:T->U, val:T):U {
    return (val != null ? func(val) : null);
  }
  
  private static var HEX_CHARS:Vector<String> = Vector.fromArrayCopy([
       "0", "1", "2", "3", "4", "5", "6", "7"
      ,"8", "9", "a", "b", "c", "d", "e", "f"
    ]);
  
  public static inline function hex2(n:Int):String {
    return HEX_CHARS[(n >> 4) & 0xF] + HEX_CHARS[n & 0xF];
  }
}
