package sk.thenet.audio.minimod;

import haxe.ds.Vector;

typedef Instrument = {
     name   :String
    ,samples:Int
    ,data   :Vector<Vector<Float>>
  };
