package sk.thenet.app;

import haxe.io.Bytes;
import sk.thenet.app.Embed;
import sk.thenet.event.Event;
import sk.thenet.event.Source;
import sk.thenet.plat.Platform;

/**
##Assets##

Assets represent external resources, such as bitmap files and sounds, that are
used in the application. These should be initialised with
`ApplicationInit.Assets` passed to the constructor of `Application`.

There are currently four types of assets:

 - `sk.thenet.app.asset.Bitmap` - A 2D bitmap file.
 - `sk.thenet.app.asset.Sound` - A sound sample.
 - `sk.thenet.app.asset.Bind` - A function bound to the loading / reloading of
    other assets. It is not an asset itself, but it can generate bitmaps, etc
    dynamically from other assets.
 - `sk.thenet.app.asset.Trigger` - Same as `Bind`, but can be used to trigger
    other assets as well.

####Event details####

 - `"change"` (class: `Event`) - Fired whenever the asset is loaded or
    reloaded. It is preferable to use `Bind` instead of listening directly for
    this event.
 */
class Asset extends Source {
  public var manager:AssetManager;
  public var type    (default, null):AssetType;
  public var id      (default, null):String;
  public var filename(default, null):String;
  public var status  (default, null):AssetStatus = AssetStatus.None;
  
  private function new(type:AssetType, id:String, ?filename:String) {
    super();
    this.type     = type;
    this.id       = id;
    this.filename = filename;
  }
  
  /**
Updates the asset with the given binary `data`. The format of the data depends
on the type of asset.
   */
  public function update(data:Bytes):Void {
    fireEvent(new Event(this, "change"));
  }
  
  /**
Starts the preloading of this asset. Called automatically by `AssetManager`.
   */
  public dynamic function preload():Void {}
  
  @:dox(hide)
  override public function listen<T:Event>(
    type:String, listener:T->Bool, ?priority:Bool = false
  ):Void {
    super.listen(type, listener, priority);
    if (type == "change" && status == Loaded) {
      var ev = new Event(this, "change");
      listener((cast ev:T));
    }
  }
}

/**
##Asset status##

Status of asset, used to tell whether a given asset is loaded or loading.
 */
enum AssetStatus {
  None;
  Error(msg:String);
  Loading(completion:Float);
  Loaded;
  Reloading(completion:Float);
}

/**
##Asset type##

@see `Asset`
 */
enum AssetType {
  Bind;
  Trigger;
  Bitmap;
  Sound;
  Binary;
}
