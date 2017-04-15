package sk.thenet.event;

interface ISource {
  public function listen<T:Event>(type:String, listener:T->Bool):Void;
}
