package sk.thenet.format;

import haxe.io.Bytes;

/**
##Bytes tools##

This class provides some utility functions for working with `haxe.io.Bytes`.
It is meant to be used as a static extension
(`using sk.thenet.format.BytesUtils`).
 */
class BytesTools {
  /*
  public static inline function endianSwapInt32(val:Int):Int {
    // 0xAABBCCDD
    val = (val >>> 16) | (val << 16); // 0xCCDDAABB
    val = ((val >> 8) & 0xFF00FF) | ((val << 8) & 0xFF00FF00); // 0xDDCCBBAA
    return val;
  }
  */
  
  /**
@return A 32-bit signed integer read in low-endian byte order from `bytes` at
`pos`.
   */
  public static inline function readLEInt32(bytes:Bytes, pos:Int):Int {
    return (bytes.get(pos) << 24)
        | (bytes.get(pos + 1) << 16)
        | (bytes.get(pos + 2) << 8)
        | bytes.get(pos + 3);
  }
  
  /**
Writes a 32-bit signed integer `val` into `bytes` at `pos` in low-endian byte
order.
   */
  public static inline function writeLEInt32(
    bytes:Bytes, pos:Int, val:Int
  ):Void {
    bytes.set(pos    ,  val >>> 24        );
    bytes.set(pos + 1, (val >>  16) & 0xFF);
    bytes.set(pos + 2, (val >>  8 ) & 0xFF);
    bytes.set(pos + 3, (val       ) & 0xFF);
    //bytes.setInt32(pos, endianSwapInt32(val));
  }
  
  /**
@return A 32-bit signed integer read in big-endian byte order from `bytes` at
`pos`.
   */
  public static inline function readBEInt32(bytes:Bytes, pos:Int):Int {
    return bytes.get(pos)
        | (bytes.get(pos + 1) << 8)
        | (bytes.get(pos + 2) << 16)
        | (bytes.get(pos + 3) << 24);
  }
  
  /**
@return A 16-bit unsigned integer read in low-endian byte order from `bytes` at
`pos`.
   */
  public static inline function readLEInt16(bytes:Bytes, pos:Int):Int {
    return (bytes.get(pos) << 8) | bytes.get(pos + 1);
  }
  
  /**
@return A 16-bit unsigned integer read in big-endian byte order from `bytes` at
`pos`.
   */
  public static inline function readBEInt16(bytes:Bytes, pos:Int):Int {
    return bytes.get(pos) | (bytes.get(pos + 1) << 8);
  }
}
