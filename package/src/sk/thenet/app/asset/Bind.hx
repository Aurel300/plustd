package sk.thenet.app.asset;

import sk.thenet.app.Asset;
import sk.thenet.app.AssetManager;
import sk.thenet.event.Event;

/**
##Asset - Bind##

Represents a function bound to other assets. The function is first called when
ALL of the bound assets have been loaded. Subsequent calls are triggered when
ANY of the bound assets change.
 */
class Bind extends Asset {
  public var bindTo(default, null):Array<String>;
  public var func  (default, null):AssetManager->Event->Bool;
  
  /**
Creates a new Bind, bound to the given assets (using their id).
   */
  public function new(
    bindTo:Array<String>, func:AssetManager->Event->Bool
  ) {
    super(AssetType.Bind, "", null);
    this.bindTo = bindTo;
    this.func = func;
  }
}
