package sk.thenet.audio.minimod;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.ds.DynamicVector;
import sk.thenet.plat.Platform;

typedef Riff = {
     instr :String
    ,beat  :Int
    ,start :Int
    ,repeat:Int
    ,notes :Array<Array<Int>>
  };

typedef Track = {
     name :String
    ,tempo:Int
    ,riffs:Array<Riff>
  };

class Minimod {
  public static inline var SAMPLES:Int = 8192;
  
  public var paused(default, set):Bool;
  private inline function set_paused(paused:Bool):Bool {
    this.paused = paused;
    if (paused) {
      out.stop();
    } else {
      out.play();
    }
    return paused;
  }
  
  public var position(get, set):Int;
  private inline function get_position():Int {
    return patpos;
  }
  private inline function set_position(pos:Int):Int {
    if (pattern == null) {
      return 0;
    }
    patpos = 0;
    while (patpos < pattern.length && pos > 0) {
      patpos += pattern[patpos] + 1;
      pos--;
    }
    return patpos;
  }
  
  public var volume:Float;
  
  public var playlist:Array<String>;
  
  // Audio
  private var out    :Output;
  private var channum:Int;
  
  // User configuration
  private var tracks     :Map<String, Track>;
  private var tracknum   :Map<String, Int>;
  private var trackdata  :Array<Vector<Int>>;
  private var instruments:Map<String, Instrument>;
  private var instrnum   :Map<String, Int>;
  private var instrdata  :DynamicVector<Vector<Float>>;
  
  // Currently playing
  private var playing :String;
  private var pattern :Vector<Int>;
  private var patpos  :Int;
  private var channels:Vector<Int>;
  private var chanpos :Vector<Int>;
  public  var beat    :Int;
  public  var tempo   :Int;
  private var repeat  :Bool;
  
  public function new(?channum:Int = 40) {
    volume   = 1.0;
    playlist = [];
    
    out          = Platform.createAudioOutput();
    out.sample   = sample;
    this.channum = channum;
    
    this.paused = true;
    
    tracks      = new Map();
    tracknum    = new Map();
    trackdata   = [];
    instruments = new Map();
    instrnum    = new Map();
    instrdata   = new DynamicVector<Vector<Float>>(10);
    
    playing  = "";
    pattern  = null;
    patpos   = 0;
    channels = new Vector(channum);
    chanpos  = new Vector(channum);
    beat     = 0;
    tempo    = 0;
    repeat   = true;
    resetChannels();
  }
  
  inline private function resetChannels():Void {
    for (i in 0...channum) {
      channels[i] = -1;
      chanpos[i]  = 0;
    }
  }
  
  public function updateTrack(track:Track):Void {
    var pos = trackdata.length;
    if (tracks.exists(track.name)) {
      pos = tracknum[track.name];
    } else {
      tracknum[track.name] = pos;
    }
    tracks[track.name] = track;
    if (pos == trackdata.length) {
      trackdata.push(makeTrack(track));
    } else {
      trackdata[pos] = makeTrack(track);
    }
  }
  
  private function makeTrack(track:Track):Vector<Int> {
    var len = 0;
    var riffs = [ for (r in track.riffs) {
        var end = r.start + r.notes[0].length * r.beat * r.repeat;
        if (end > len) {
          len = end;
        }
        [ for (i in 0...r.start) [] ].concat([
            for (rep in 0...r.repeat) for (note in 0...r.notes[0].length) for (b in 0...r.beat)
              (b == 0 ? [ for (layer in r.notes) if (layer[note] != -1) instrnum[r.instr] + layer[note] ] : [])
          ]);
      } ];
    var ret = [];
    for (i in 0...len) {
      var burst = [];
      for (r in riffs) {
        if (i < r.length) burst = burst.concat(r[i]);
      }
      ret.push(burst.length);
      for (b in burst) ret.push(b);
    }
    return Vector.fromArrayCopy(ret);
  }
  
  public function updateInstrument(instr:Instrument):Void {
    var pos = instrdata.count;
    if (instruments.exists(instr.name)) {
      pos = instrnum[instr.name];
    } else {
      instrnum[instr.name] = pos;
    }
    instruments[instr.name] = instr;
    for (i in 0...instr.samples) {
      if (pos == instrdata.count) {
        instrdata.add(instr.data[i]);
      } else {
        instrdata.vector[pos] = instr.data[i];
      }
      pos++;
    }
  }
  
  public function playTrack(
    id:String, ?reset:Bool = false, ?repeat:Bool = true
  ):Void {
    this.repeat = repeat;
    if (playing == id) {
      return;
    }
    playing = id;
    if (reset) {
      resetChannels();
    }
    pattern = trackdata[tracknum[id]];
    tempo = tracks[id].tempo;
    patpos = 0;
    set_paused(false);
  }
  
  private function sample(offset:Float, buffer:Vector<Float>):Void {
    function assignChannel(instr:Int):Void {
      for (c in 0...channum) if (channels[c] == -1) {
        channels[c] = instr;
        chanpos[c]  = -beat;
        return;
      }
    }
    
    for (i in 0...SAMPLES * 2) {
      buffer[i] = 0;
    }
    if (pattern == null) {
      return;
    }
    while (beat < SAMPLES) {
      var num = pattern[patpos++];
      for (n in 0...num) {
        assignChannel(pattern[patpos++]);
      }
      if (patpos >= pattern.length) {
        patpos = 0;
        if (playlist.length > 0) {
          playTrack(playlist.shift(), false, repeat);
        } else if (!repeat) {
          playing = "";
          pattern = null;
          tempo = 10000;
        }
      }
      beat += tempo;
    }
    if (pattern == null) {
      return;
    }
    for (ci in 0...channels.length) {
      if (channels[ci] != -1) {
        var instr = instrdata.vector[channels[ci]];
        var cpos  = chanpos[ci];
        var spos  = FM.maxI(0, -cpos);
        var di    = spos * 2;
        for (i in spos...SAMPLES) {
          buffer[di++] += instr[cpos + i];
          buffer[di++] += instr[cpos + i];
        }
        chanpos[ci] += SAMPLES;
        if (instr.length - chanpos[ci] < SAMPLES) {
          channels[ci] = -1;
          chanpos[ci]  = 0;
        }
      }
    }
    beat -= SAMPLES;
    for (i in 0...SAMPLES * 2) {
      buffer[i] *= volume;
    }
  }
}
