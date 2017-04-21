package sk.thenet.event;

/**
##Event source interface##
 */
interface ISource {
  public function listen<T:Event>(
      type:String, listener:T->Bool, ?priority:Bool = false
    ):Void;
}
