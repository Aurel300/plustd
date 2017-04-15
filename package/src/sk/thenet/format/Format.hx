package sk.thenet.format;

import haxe.io.Bytes;

/**
##Format##

This generic interface defines methods needed to convert a specific data type
(as given in the type parameter) to and from specific formats in files, network
transfers, etc.
 */
interface Format<T> {
  /**
Encodes the given object into a binary format.
   */
  public function encode(obj:T):Bytes;
  
  /**
Decodes an object from a binary format.
   */
  public function decode(data:Bytes):T;
}
