package sk.thenet.app;

import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.event.EFile;
import sk.thenet.bmp.Bitmap;

/**
##Asset manager##

This class allows managing a set of assets, such as bitmaps or sounds. It allows
"hot reloading" - reloading assets in a running application (without restarting
the application) whenever the assets change. There are two modes of hot
reloading available:

 - Local - Available on platforms with filesystem access. Periodically checks
   for changes in tracked files and reloads them if necessary.
 - Remote - Available on platforms with network access. Connects to an asset
   server which serves assets whenever they are changed. The asset server itself
   is provided with the plustd library.
 */
class AssetManager {
  private var assets    (default, null):Array<Asset>;
  private var assetsMap (default, null):Map<String, Asset>;
  private var assetsBind(default, null):Map<String, Array<String>>;
  
  public function new(?assets:Array<Asset>){
    if (assets == null){
      assets = [];
    }
    this.assets = assets;
    assetsMap = new Map<String, Asset>();
    assetsBind = new Map<String, Array<String>>();
    for (a in assets){
      if (a.type == Bind){
        var bind = (cast a:AssetBind);
        for (b in bind.bindTo){
          if (!assetsBind.exists(b)){
            assetsBind.set(b, []);
          }
          assetsBind.get(b).push(bind.id);
        }
        bind.func(this);
      }
      assetsMap.set(a.id, a);
    }
  }
  
  public function getBitmap(id:String):Bitmap {
    return (cast (assetsMap.get(id)):AssetBitmap).current;
  }
  
  public function attachConsole(console:Console):Void {
    console.listen("file", handleFile);
    for (a in assets){
      if (a.filename != null){
        console.monitor(a.filename);
      }
    }
  }
  
  private function handleFile(ev:EFile):Bool {
    for (asset in assets){
      if (asset.filename != null && asset.filename == ev.name){
        asset.update(ev.data);
        if (assetsBind.exists(asset.id)){
          for (bind in assetsBind.get(asset.id)){
            var cbind = (cast (assetsMap.get(bind)):AssetBind);
            cbind.func(this);
          }
        }
      }
    }
    /*
    if (assetsMap.exists(ev.name)){
      assetsMap.get(ev.name).update(ev.data);
      if (assetsBind.exists(ev.name))
      return true;
    }
    */
    return false;
  }
}
