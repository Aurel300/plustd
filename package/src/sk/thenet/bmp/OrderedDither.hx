package sk.thenet.bmp;

import haxe.ds.Vector;

class OrderedDither {
  public static var BAYER_2 (default, null):Vector<Int> = generateBayer(2);
  public static var BAYER_4 (default, null):Vector<Int> = generateBayer(4);
  public static var BAYER_8 (default, null):Vector<Int> = generateBayer(8);
  public static var BAYER_16(default, null):Vector<Int> = generateBayer(16);
  
  public static function generateBayer(size:Int):Vector<Int> {
    inline function interleave(a:Int, b:Int):Int {
      var ret:Int = 0;
      var mask:Int = 1;
      for (i in 0...16) {
        ret |= ((a & mask) | ((b & mask) << 1)) << i;
        mask *= 2;
      }
      return ret;
    }
    inline function reverse(a:Int):Int {
      return (((a * 0x0802 & 0x22110) | (a * 0x8020 & 0x88440)) * 0x10101 >> 16)
        & 0xFF;
    }
    
    var ret = new Vector<Int>(size * size);
    var i = 0;
    for (y in 0...size) for (x in 0...size) {
      ret[i] = Std.int(reverse(interleave(x ^ y, x)) / (size * size));
      i++;
    }
    return ret;
  }
}
