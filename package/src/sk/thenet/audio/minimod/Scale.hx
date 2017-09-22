package sk.thenet.audio.minimod;

import haxe.ds.Vector;

class Scale {
  public static inline var STEP_JTT:Float = 1.059463094;
  
  public static function chromatic(freq:Float, steps:Int):Scale {
    return new Scale(Vector.fromArrayCopy([freq].concat([
        for (i in 1...steps) freq *= STEP_JTT
      ])), 12);
  }
  
  public var steps  :Vector<Float>;
  public var periods:Vector<Float>;
  
  private var octaveStep:Int;
  
  public function new(steps:Vector<Float>, octaveStep:Int) {
    this.steps   = steps;
    this.periods = steps.map(function(freq) return 44100 / freq);
    this.octaveStep = octaveStep;
  }
  
  public function instrument(
    name:String, func:Float->Float->Vector<Float>
  ):Instrument {
    var data = new Vector<Vector<Float>>(steps.length);
    for (i in 0...steps.length) {
      data[i] = func(steps[i], periods[i]);
    }
    return {
         name:    name
        ,samples: steps.length
        ,data:    data
      };
  }
  
  public function octave(s:Int):Int {
    return s + octaveStep;
  }
  
  public function octaves(n:Int, s:Int):Int {
    return s + octaveStep * n;
  }
}
