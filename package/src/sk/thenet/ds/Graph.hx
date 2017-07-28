package sk.thenet.ds;

class Graph<T> {
  private var nodes:VectorSet<T>;
  private var edges:VectorEquatableSet<GraphEdge<T>>;
  
  public function new() {
    nodes = new VectorSet();
    edges = new VectorEquatableSet();
  }
  
  public inline function add(obj:T):Bool {
    return nodes.add(obj);
  }
  
  public inline function has(obj:T):Bool {
    return nodes.has(obj);
  }
  
  public inline function connect(a:T, b:T):Bool {
    return edges.add(new GraphEdge(a, b));
  }
  
  public inline function disconnect(a:T, b:T):Bool {
    return edges.remove(new GraphEdge(a, b));
  }
  
  public inline function connected(a:T, b:T):Bool {
    return edges.has(new GraphEdge(a, b));
  }
  
  public inline function remove(obj:T):Bool {
    return nodes.remove(obj);
  }
}

class GraphEdge<T> implements Equatable<GraphEdge<T>> {
  public var from(default, null):T;
  public var to  (default, null):T;
  
  public function new(from:T, to:T) {
    this.from = from;
    this.to = to;
  }
  
  public function equals(obj:GraphEdge<T>):Bool {
    return from == obj.from && to == obj.to;
  }
}
