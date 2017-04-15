package sk.thenet.fsm;

/**
##Finite State Machine - Memory##

This interface should be implemented by classes storing generic 'memory'
(outside of states) which can be accessed by FSM states.

The type parameter represents a `sk.thenet.fsm.State`.
 */
interface Memory<T:State> {
  /**
Resets memory when the FSM is reset.
   */
  public function reset():Void;
}
