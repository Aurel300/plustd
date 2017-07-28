package sk.thenet.ds;

class VectorEquatableSet<T:Equatable<T>> extends VectorSet<T> {
  public function new(?reserve:Int = 16) {
    super(reserve);
  }
  
  override public function has(obj:T):Bool {
    for (i in 0...size) {
      if (data[i].equals(obj)) {
        return true;
      }
    }
    return false;
  }
  
  override public function remove(obj:T):Bool {
    for (i in 0...size) {
      if (data[i].equals(obj)) {
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
