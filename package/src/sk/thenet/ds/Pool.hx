package sk.thenet.ds;

import haxe.ds.Vector;

class Pool<T> {
  public var vector  (default, null):Vector<T>;
  public var capacity(default, null):Int;
  public var count   (default, null):Int;
  
  private var spawn:Void->T;
  private var reset:T->Void;
  
  /**
Constructs a new pool with the initial `capacity`.
   */
  public function new(capacity:Int, spawn:Void->T, reset:T->Void) {
    vector = new Vector(capacity);
    this.capacity = capacity;
    this.spawn    = spawn;
    this.reset    = reset;
    count = 0;
    for (i in 0...capacity) {
      vector[i] = spawn();
    }
  }
  
  /**
@return An instance from the pool. May grow the pool if necessary.
   */
  public function get():T {
    if (count >= capacity) {
      var old = vector;
      vector = new Vector(capacity * 2);
      Vector.blit(old, 0, vector, 0, capacity);
      capacity *= 2;
      for (i in count...capacity) {
        vector[i] = spawn();
      }
    }
    return vector[count++];
  }
  
  /**
Places an instance back into the pool.
   */
  public function recycle(e:T):Void {
    var index = -1;
    for (i in 0...count) {
      if (vector[i] == e) {
        index = i;
        break;
      }
    }
    if (index == -1) {
      return;
    }
    reset(e);
    if (index == count - 1) {
      count--;
      return;
    }
    var t = vector[index];
    vector[index] = vector[count - 1];
    vector[count - 1] = t;
    count--;
  }
}