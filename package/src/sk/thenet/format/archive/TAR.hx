package sk.thenet.format.archive;

import haxe.io.Bytes;
import sk.thenet.format.Archive;
import sk.thenet.format.Format;

class TAR implements Format<Archive> {
  public function new() {}
  
  public function encode(obj:Archive):Bytes {
    var zerobuf = Bytes.alloc(512);
    var buf = new haxe.io.BytesBuffer();
    function toOctal(n:Int, l:Int):String {
      return [ for (i in 0...l)
          ["0", "1", "2", "3", "4", "5", "6", "7"][(n >> ((l - 1 - i) * 3)) & 7]
        ].join("");
    }
    var blocks = [];
    for (f in obj.files) {
      blocks.push(buf.length);
      // File name (100)
      buf.addString(f.path);
      buf.addBytes(zerobuf, 0, 100 - f.path.length);
      // File mode (8)
      buf.addString("000755 ");
      buf.addByte(0);
      // Owner's numeric user ID (8)
      buf.addString("000001 ");
      buf.addByte(0);
      // Group's numeric user ID (8)
      buf.addString("000001 ");
      buf.addByte(0);
      // File size in bytes (octal base) (12)
      buf.addString(toOctal(f.data.length, 11));
      buf.addString(" ");
      // Last modification time in numeric Unix time format (octal) (12)
      buf.addString("13163444645 ");
      // Checksum for header record (8)
      buf.addString("        ");
      // Type flag (1)
      buf.addString("0");
      // Name of linked file (100)
      buf.addBytes(zerobuf, 0, 100);
      // Magic (6)
      buf.addString("ustar");
      buf.addByte(0);
      // Ustar version (2)
      buf.addString("00");
      // Owner user name (32)
      buf.addBytes(zerobuf, 0, 32);
      // Owner group name (32)
      buf.addBytes(zerobuf, 0, 32);
      // Device major number (8)
      buf.addString("000000 ");
      buf.addByte(0);
      // Device minor number (8)
      buf.addString("000000 ");
      buf.addByte(0);
      // Filename prefix (155) + Header padding (12)
      buf.addBytes(zerobuf, 0, 155 + 12);
      // Data
      buf.add(f.data);
      // Data padding
      if (f.data.length % 512 != 0) {
        buf.addBytes(zerobuf, 0, 512 - (f.data.length % 512));
      }
    }
    buf.add(zerobuf);
    buf.add(zerobuf);
    var bytes = buf.getBytes();
    for (b in blocks) {
      var sum = 0;
      for (i in 0...512) sum += bytes.get(b + i);
      var cb = new haxe.io.BytesBuffer();
      cb.addString(toOctal(sum, 6));
      cb.addByte(0);
      cb.addString(" ");
      var cbb = cb.getBytes();
      bytes.blit(b + 148, cbb, 0, cbb.length);
    }
    return bytes;
  }
  
  public function decode(data:Bytes):Archive {
    return null;
  }
}