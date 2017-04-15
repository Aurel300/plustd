package sk.thenet.fsm;

interface Transition<T> {
  public function apply():Void;
}
