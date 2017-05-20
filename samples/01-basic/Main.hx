import haxe.ds.Vector;
import sk.thenet.app.*;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

class Main extends Application {
  public static function main() Platform.boot(function() new Main());
  
  public function new(){
    super([
         Framerate(60)
        ,Window("plustd demo", 160, 160)
        ,Surface(40, 40, 2)
      ]);
    addState(new Test(this));
    mainLoop();
  }
}

class Test extends State {
  private var ph:Int = 0;
  
  public function new(app:Application){
    super("test", app);
  }
  
  override public function tick(){
    // adapted from:
    // https://codegolf.stackexchange.com/a/35609/73
    app.bitmap.setVector(Vector.fromArrayCopy([
        for (oy in 0...40) for (ox in 0...40){
          var x = (ox * (1 + ph / 1000)).floor() + ph;
          var y = (oy * (1 + ph / 930)).floor()
            + (Math.sin(((ph % 310) / 310) * Math.PI * 2) * 20).floor();
          new Colour(0xFF000000)
            .setRi(y ^ (y - x) ^ x)
            .setGi((x - 40 - ox) ^ 2 + (y - 40 - oy) ^ 2)
            .setBi(x ^ (x - y) ^ y);
        }
      ]));
    ph++;
  }
}
