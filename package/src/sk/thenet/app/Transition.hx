package sk.thenet.app;

import sk.thenet.fsm.Transition as FSMTransition;

/**
##Application - Transition##

Base class for representing application transitions. This class is currently not
used by Application, as states are applied directly.

@see `sk.thenet.app.Application`
 */
class Transition implements FSMTransition<State> {
  public function apply():Void {}
}
