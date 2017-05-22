package sk.thenet.app;

import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.app.asset.Trigger as AssetTrigger;
import sk.thenet.audio.Sound;
import sk.thenet.event.EFile;
import sk.thenet.event.Event;
import sk.thenet.bmp.Bitmap;

/**
##Asset manager##

This class allows managing a set of assets, such as bitmaps or sounds. It allows
"hot reloading" - reloading assets in a running application (without restarting
the application) whenever the assets change. There are two modes of hot
reloading available:

 - Local - Available on platforms with filesystem access. Periodically checks
   for changes in tracked files and reloads them if necessary. (Currently
   unavailable because no system platforms are supported yet.)
 - Remote - Available on platforms with network access. Connects to an asset
   server which serves assets whenever they are changed. The asset server itself
   is provided with the plustd library. This is enabled using the
   `ApplicationInit` `ConsoleRemote`.

This class should not be constructed directly - use `ApplicationInit` `Assets`
instead.
 */
@:allow(sk.thenet.app)
class AssetManager {
  /**
`true` iff all the assets have been loaded.
   */
  public var assetsLoaded(default, null):Bool;
  
  private var assets:Array<Asset>;
  private var assetsMap:Map<String, Asset>;
  
  private function new(?assets:Array<Asset>){
    if (assets == null){
      assets = [];
    }
    this.assets = assets;
    assetsMap = new Map();
    assetsLoaded = true;
    for (a in assets){
      add(a);
    }
  }
  
  private function add(a:Asset):Void {
    a.manager = this;
    switch (a.type){
      case Bind | Trigger:
      var bind = (cast a:AssetBind);
      for (b in bind.bindTo){
        if (!assetsMap.exists(b)){
          throw "invalid bind";
        }
        assetsMap.get(b).listen("change", function(event:Event):Bool {
            for (b in bind.bindTo){
              if (!isLoaded(b)){
                return false;
              }
            }
            return bind.func(this, event);
          });
      }
      
      case _:
      if (a.status != Loaded){
        assetsLoaded = false;
      }
    }
    if (a.id != ""){
      assetsMap.set(a.id, a);
    }
  }
  
  private function preload():Void {
    for (a in assets){
      if (a.type != Bind && a.type != Trigger && a.status != Loaded){
        a.preload();
      }
    }
  }
  
  /**
@return `true` iff the asset with the given `id` has been loaded. `false` if an
asset with that id does not exist.
   */
  public function isLoaded(id:String):Bool {
    if (assetsMap.exists(id)){
      return assetsMap.get(id).status == Loaded;
    }
    return false;
  }
  
  /**
Returns the current loaded `Bitmap` of the asset with the given `id`. `null` if
that asset has not been loaded yet.

Throws an error if the given asset is not a bitmap asset.
   */
  public function getBitmap(id:String):Bitmap {
    if (!isLoaded(id)){
      return null;
    }
    if (assetsMap.get(id).type != Bitmap){
      throw "asset type mismatch";
    }
    return (cast (assetsMap.get(id)):AssetBitmap).current;
  }
  
  /**
Returns the current loaded `Sound` of the asset with the given `id`. `null` if
that asset has not been loaded yet.

Throws an error if the given asset is not a sound asset.
   */
  public function getSound(id:String):Sound {
    if (!isLoaded(id)){
      return null;
    }
    if (assetsMap.get(id).type != Sound){
      throw "asset type mismatch";
    }
    return (cast (assetsMap.get(id)):AssetSound).current;
  }
  
  private function attachConsole(console:Console):Void {
    console.listen("file", handleFile);
    for (a in assets){
      if (a.filename != null){
        console.monitor(a.filename);
      }
    }
  }
  
  private function updateLoad(id:String):Void {
    assetsLoaded = true;
    for (asset in assets){
      if (asset.type != Bind && asset.status != Loaded){
        assetsLoaded = false;
        return;
      }
    }
  }
  
  private function handleFile(ev:EFile):Bool {
    trace("handling " + ev.name);
    for (asset in assets){
      if (asset.filename != null && asset.filename == ev.name){
        asset.update(ev.data);
        return true;
      }
    }
    return false;
  }
}
