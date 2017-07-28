package sk.thenet.crypto.hash;

import haxe.ds.Vector;
import haxe.io.Bytes;

/**
##Hash - CRC-32##
 */
class CRC {
  private static var crc:Vector<UInt> = createCRC();
  
  private static inline function createCRC():Vector<UInt> {
    var c:UInt;
    var ret = new Vector<UInt>(256);
    for (n in 0...256) {
      c = n;
      for (k in 0...8) {
        if (c & 1 == 1) {
          c = 0xEDB88320 ^ (c >>> 1);
        } else {
          c = c >>> 1;
        }
      }
      ret[n] = c;
    }
    return ret;
  }
  
  /**
@return The CRC-32 of the given `data`.
   */
  public static inline function calculate(data:Bytes):UInt {
    return calculateRange(data, 0, data.length);
  }
  
  /**
@return The CRC-32 of the given range in `data`.
   */
  public static function calculateRange(data:Bytes, start:Int, len:Int):UInt {
    var c:UInt = 0xFFFFFFFF;
    for (i in start...start + len) {
      c = crc[(c ^ data.get(i)) & 0xFF] ^ (c >>> 8);
    }
    return c ^ 0xFFFFFFFF;
  }
}
