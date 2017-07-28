package sk.thenet.app.asset;

import sk.thenet.app.Asset;
import sk.thenet.app.AssetManager;
import sk.thenet.event.Event;

/**
##Asset - Trigger##

Represents a function bound to other assets. The function is first called when
ALL of the bound assets have been loaded. Subsequent calls are triggered when
ANY of the bound assets change.

The difference between `Trigger` and `Bind` is that `Trigger` has an id of its
own. This allows other binds and triggers to bind to it, creating a chain of
asset dependencies.
 */
class Trigger extends Bind {
  /**
Creates a new Trigger with the given `id`, bound to the given assets (using
their id).
   */
  public function new(
    id:String, bindTo:Array<String>, func:AssetManager->Event->Bool
  ) {
    super(bindTo, function(assetManager:AssetManager, event:Event):Bool {
        func(assetManager, event);
        status = Loaded;
        update(null);
        return false;
      });
    this.id = id;
    type = AssetType.Trigger;
  }
}
