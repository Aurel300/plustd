package sk.thenet.ds;

import haxe.ds.Vector;

/**
##Dynamic vector##

A dynamic (auto-growing) vector.
 */
@:generic
class DynamicVector<T> {
  public var vector  (default, null):Vector<T>;
  public var capacity(default, null):Int;
  public var count   (default, null):Int;
  
  /**
Constructs a new dynamic vector with the initial `capacity`.
   */
  public function new(capacity:Int) {
    vector = new Vector<T>(capacity);
    this.capacity = capacity;
    count = 0;
  }
  
  /**
Appends an object to the end of the vector. Resizes if necessary.

@return `true` iff the vector has been resized.
   */
  public function add(e:T):Bool {
    if (count >= capacity) {
      var old = vector;
      vector = new Vector(capacity * 2);
      Vector.blit(old, 0, vector, 0, capacity);
      capacity *= 2;
      vector[count++] = e;
      return true;
    }
    vector[count++] = e;
    return false;
  }
  
  /**
Removes an element from the vector, by reference. This first looks up the
index of the element.

@return `true` iff the element was found in the vector and was removed.
   */
  public function remove(e:T):Bool {
    var index = indexOf(e);
    if (index != -1) {
      removeIndex(index);
      return true;
    }
    return false;
  }
  
  /**
Looks up the index of an element. Returns `-1` if not found.
   */
  public function indexOf(e:T):Int {
    for (i in 0...count) {
      if (vector[i] == e) {
        return i;
      }
    }
    return -1;
  }
  
  /**
Removes an element from the vector, by index.
   */
  public function removeIndex(i:Int):Void {
    for (j in 0...count - i - 1) {
      vector[i + j] = vector[i + j + 1];
    }
    count--;
    vector[count] = null;
  }
  
  /**
Clears the vector of all elements.
   */
  public function clear():Void {
    for (i in 0...count) {
      vector[i] = null;
    }
    count = 0;
  }
  
  /**
Returns an iterator for this vector. If the vector is modified, the iterator
should not be used anymore.
   */
  public function iterator():Iterator<T> {
    var pos = 0;
    return {
         hasNext: function() return pos < count
        ,next: function() return vector[pos++]
      };
  }
}
