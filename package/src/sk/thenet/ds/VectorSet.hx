package sk.thenet.ds;

import haxe.ds.Vector;

class VectorSet<T> implements Set<T> {
  public var size(default, null):Int;
  
  private var data:Vector<T>;
  
  public function new(?reserve:Int = 16) {
    if (reserve < 1) {
      throw "invalid argument";
    }
    size = 0;
    data = new Vector<T>(reserve);
  }
  
  public function has(obj:T):Bool {
    for (i in 0...size) {
      if (data[i] == obj) {
        return true;
      }
    }
    return false;
  }
  
  public function resize(size:Int):Void {
    this.size = size;
    if (size > data.length) {
      var redata = new Vector<T>(size);
      Vector.blit(data, 0, redata, 0, data.length);
      data = redata;
    }
  }
  
  public function add(obj:T):Bool {
    if (has(obj)) {
      return false;
    }
    if (size == data.length) {
      resize(size << 1);
    }
    data[size] = obj;
    size++;
    return true;
  }
  
  public function remove(obj:T):Bool {
    for (i in 0...size) {
      if (data[i] == obj) {
        if (i == size - 1) {
          data[i] = null;
        } else {
          data[i] = data[size - 1];
        }
        size--;
        return true;
      }
    }
    return false;
  }
}
