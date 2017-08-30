package sk.thenet.app;

import sk.thenet.app.Keyboard.Key;
import sk.thenet.audio.Sound;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.plat.Platform;

/**
##Application - Jam state##

This is an application state specifically intended for rapid prototyping. There
are shortcuts that may or may not be useful to you.
 */
class JamState extends State {
  /**
Shortcut for `app.assetManager`.
   */
  public var am(get, never):AssetManager;
  private inline function get_am():AssetManager {
    return app.assetManager;
    }
  
  /**
Shortcut for `app.bitmap`.
   */
  public var ab(get, never):Bitmap;
  private inline function get_ab():Bitmap {
    return app.bitmap;
  }
  
  /**
Shortcut for `app.keyboard.isHeld(key)`.
   */
  public inline function ak(key:Key):Bool {
    return app.keyboard.isHeld(key);
  }
  
  /**
Shortcut for `FM.prng.nextBool()`. Note: this uses a getter to provide a
different value every time.
   */
  public var prngB(get, never):Bool;
  private inline function get_prngB():Bool {
    return FM.prng.nextBool();
  }
  
  /**
Shortcut for `FM.prng.nextFloat()`. Note: this uses a getter to provide a
different value every time.
   */
  public var prngF(get, never):Float;
  private inline function get_prngF():Float {
    return FM.prng.nextFloat();
  }
  
  public function new(id:String, app:Application) {
    super(id, app);
  }
  
  /**s
Shortcut for `app.applyState(app.getStateById(id))`.
   */
  public inline function st(id:String):Void {
    app.applyState(app.getStateById(id));
  }
  
  /**
Shortcut for `app.assetManager.getBitmap(id)`.
   */
  public inline function amB(id:String):Bitmap {
    return am.getBitmap(id);
  }
  
  /**
Shortcut for `app.assetManager.getSound(id)`.
   */
  public inline function amS(id:String):Sound {
    return am.getSound(id);
  }
  
  /**
Shortcut for `Platform.createBitmap(w, h, c)`.
   */
  public inline function mkB(w:Int, h:Int, ?c:Colour = 0):Bitmap {
    return Platform.createBitmap(w, h, c);
  }
  
  /**
Shortcut for `phasers[id].get(tickAfter)`.
   */
  public function ph(id:String, ?tickAfter:Bool = false):Int {
    return phasers[id].get(tickAfter);
  }
  
  /**
Shortcut for `FM.prng.nextMod(mod)`.
   */
  public inline function prngM(mod:Int):Int {
    return FM.prng.nextMod(mod);
  }
}
