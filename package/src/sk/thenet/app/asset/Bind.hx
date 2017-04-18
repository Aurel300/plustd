package sk.thenet.app.asset;

import sk.thenet.app.Asset;
import sk.thenet.app.AssetManager;

class Bind extends Asset {
  public var bindTo(default, null):Array<String>;
  public var func  (default, null):AssetManager->Void;
  
  public function new(id:String, bindTo:Array<String>, func:AssetManager->Void){
    super(AssetType.Bind, id, null);
    this.bindTo = bindTo;
    this.func = func;
  }
}
