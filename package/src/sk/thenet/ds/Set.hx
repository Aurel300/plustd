package sk.thenet.ds;

interface Set<T> {
  public var size(default, null):Int;
  
  public function has(obj:T):Bool;
  
  public function add(obj:T):Bool;
  
  public function remove(obj:T):Bool;
}
