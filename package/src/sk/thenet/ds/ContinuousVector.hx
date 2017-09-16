package sk.thenet.ds;

import haxe.ds.Vector;

/**
##Continuous vector##

A dynamic (auto-growing) vector which ensures continuity in its elements for
fast iteration. The order of elements is not preserved when elements are
removed from the middle - elements from the end automatically replace them to
restore continuity.
 */
class ContinuousVector<T> {
  public var vector  (default, null):Vector<T>;
  public var capacity(default, null):Int;
  public var count   (default, null):Int;
  
  /**
Constructs a new continuous vector with the initial `capacity`.
   */
  public function new(capacity:Int) {
    vector = new Vector(capacity);
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
    if (i == count - 1) {
      vector[i] = null;
      count--;
      return;
    }
    vector[i] = vector[count - 1];
    vector[count - 1] = null;
    count--;
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
         hasNext: () -> pos < count
        ,next: () -> vector[pos++]
      };
  }
}
