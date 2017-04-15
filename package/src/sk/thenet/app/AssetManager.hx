package sk.thenet.app;

import sk.thenet.event.EFile;

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
  public var assets(default, null):Array<Asset>;
  public var assetsMap(default, null):Map<String, Asset>;
  
  public function new(){
    assets = [];
    assetsMap = new Map<String, Asset>();
  }
  
  public function attachConsole(console:Console, monitor:Array<String>):Void {
    console.listen("file", handleFile);
    for (m in monitor){
      console.monitor(m);
    }
  }
  
  private function handleFile(ev:EFile):Bool {
    if (assetsMap.exists(ev.name)){
      assetsMap.get(ev.name).update(ev.data);
      return true;
    }
    return false;
  }
}
