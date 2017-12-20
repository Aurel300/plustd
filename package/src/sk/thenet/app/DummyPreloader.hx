package sk.thenet.app;

class DummyPreloader extends Preloader {
  public var target:String;
  
  public function new(app:Application, target:String) {
    super("dummy_preloader", app);
    this.target = target;
  }
  
  override public function progress(assets:Array<Asset>):Void {
    for (a in assets) {
      if (a.type != Bitmap && a.type != Sound){
        continue;
      }
      if (a.status != Loaded) {
        return;
      }
    }
    app.applyState(app.getStateById(target));
  }
}
