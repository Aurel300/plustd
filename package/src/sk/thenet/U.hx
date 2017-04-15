package sk.thenet;

/**
##Utilities##

Utility class with some shortcut methods.
 */
class U {
  public static inline function callNotNull<T, U>(func:T->U, val:T):U {
    return (val != null ? func(val) : null);
  }
}
