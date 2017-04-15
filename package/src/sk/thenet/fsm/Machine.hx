package sk.thenet.fsm;

/**
##Finite State Machine##

An interface to represent finite state machines.

The type parameters represent (in order), a class implementing
`sk.thenet.fsm.Memory`, (which in 'formal' FSM would be a part of the
states, but for ease of access is here provided as the 'global' storage
accessible for every state), a class implementing `sk.thenet.fsm.State`,
and a class implementing `sk.thenet.fsm.Transition`.
 */
interface Machine<T:Memory<U>, U:State, V:Transition<U>> {
  /**
Resets the machine to its initial state.
   */
  public function reset():Void;
  
  /**
@return The memory storage for the machine.
   */
  public function getMemory():T;
  
  /**
@return The current state the machine is in.
   */
  public function getState():U;
  
  /*
  public function applyTransition(transition:U):T;
  */
}
