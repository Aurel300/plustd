import haxe.ds.Vector;
import sk.thenet.anim.Phaser;
import sk.thenet.app.*;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

class Main extends Application {
  public static inline var SIZE:Int = 40;
  public static inline var SCALE:Int = 2;
  
  public function new() {
    super([
         Framerate(60)
        ,Optional(Window("plustd demo", SIZE << SCALE, SIZE << SCALE))
        ,Surface(SIZE, SIZE, SCALE)
      ]);
    addState(new Fancy(this));
    mainLoop();
  }
}

class Fancy extends State {
  public function new(app:Application) {
    super("test", app);
    phasers["ph"] = new Phaser();
  }
  
  override public function tick() {
    // adapted from:
    // https://codegolf.stackexchange.com/a/35609/73
    var ph = getPhase("ph");
    var vec = new Vector<Colour>(Main.SIZE * Main.SIZE);
    var i = 0;
    for (oy in 0...Main.SIZE) for (ox in 0...Main.SIZE){
      var x = (ox * (1 + ph / 1000)).floor() + ph;
      var y = (oy * (1 + ph / 930)).floor()
        + (Math.sin(((ph % 310) / 310) * Math.PI * 2) * 20).floor();
      vec[i++] = Colour.fromARGBi(
           255
          ,y ^ (y - x) ^ x
          ,(x - 40 - ox) ^ 2 + (y - 40 - oy) ^ 2
          ,x ^ (x - y) ^ y
        );
    }
    app.bitmap.setVector(vec);
  }
}
