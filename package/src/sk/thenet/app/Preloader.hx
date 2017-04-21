package sk.thenet.app;

/**
##Application - Preloader state##

This subclass of `State` can be used to show loading progress when assets are
loading.

@see `Application`
@see `State`
 */
class Preloader extends State {
  public function new(id:String, app:Application){
    super(id, app);
  }
  
  /**
Called with the array of `Asset`s whenever there is a change to their status.

@see `AssetStatus`
   */
  public function progress(assets:Array<Asset>):Void {}
}
