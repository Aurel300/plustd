package sk.thenet.event;

/**
##Event source##

The base class which can fire events and allows listeners to be attached.
 */
class Source implements ISource {
  private var listenTo:Array<String>;
  private var listeners:Array<Dynamic->Bool>;
  
  public function new(){
    listenTo = [];
    listeners = [];
  }
  
  /**
Fires an event to its listeners. Listeners are invoked in the order they were
added until a listener returns `true` or there are no more listeners to invoke.
   */
  public function fireEvent(event:Event):Void {
    for (i in 0...listenTo.length){
      if (listenTo[i] == event.type && listeners[i](event)){
        break;
      }
    }
  }
  
  /**
Adds a listener to an event type.

@param type Type of event to listen for.
@param listener A function which takes the event as its parameter and returns
`true` iff the event was handled.
   */
  public function listen<T:Event>(type:String, listener:T->Bool):Void {
    listenTo.push(type);
    listeners.push(listener);
  }
  
  /**
Forwards events of the given type from the given source.
   */
  public function forward<T:Event>(type:String, source:Source):Void {
    source.listen(type, function(event:T){
        fireEvent(event);
        return true;
      });
  }
}
