package sk.thenet.fsm;

/**
##Finite State Machine - State##

This interface represents an individual state in an FSM.
 */
interface State {
  /**
Called when this state is entered.
   */
  public function to():Void;
  
  /**
Called when this state is left.
   */
  public function from():Void;
}
