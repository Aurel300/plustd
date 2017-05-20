package sk.thenet.plat.common.format.bmp;

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.zip.Compress;
import haxe.zip.Uncompress;
import sk.thenet.FM;
import sk.thenet.bmp.Bitmap;
import sk.thenet.bmp.Colour;
import sk.thenet.crypto.hash.CRC;
import sk.thenet.format.Format;
import sk.thenet.plat.Platform;

using sk.thenet.format.BytesTools;

class PNG implements Format<Bitmap> {
  private static var encodeLMinDepth = Vector.fromArrayCopy([
       1,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
      ,8,4,8,8,8,8,8,8,8,8,8,8,8,8,8,8
      ,8,8,4,8,8,8,8,8,8,8,8,8,8,8,8,8
      ,8,8,8,4,8,8,8,8,8,8,8,8,8,8,8,8
      ,8,8,8,8,4,8,8,8,8,8,8,8,8,8,8,8
      ,8,8,8,8,8,2,8,8,8,8,8,8,8,8,8,8
      ,8,8,8,8,8,8,4,8,8,8,8,8,8,8,8,8
      ,8,8,8,8,8,8,8,4,8,8,8,8,8,8,8,8
      ,8,8,8,8,8,8,8,8,4,8,8,8,8,8,8,8
      ,8,8,8,8,8,8,8,8,8,4,8,8,8,8,8,8
      ,8,8,8,8,8,8,8,8,8,8,2,8,8,8,8,8
      ,8,8,8,8,8,8,8,8,8,8,8,4,8,8,8,8
      ,8,8,8,8,8,8,8,8,8,8,8,8,4,8,8,8
      ,8,8,8,8,8,8,8,8,8,8,8,8,8,4,8,8
      ,8,8,8,8,8,8,8,8,8,8,8,8,8,8,4,8
      ,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,1
    ]);
  
  /**
These values tell the encoder which colour types should be attempted to be
compressed.

 - `encL` - grayscale
 - `encRGB` - truecolour (RGB)
 - `encI` - indexed
 - `encIA` - indexed with alpha
 - `encLA` - grayscale with alpha
 - `encRGBA` - truecolour with alpha (RGBA)

By default, only `encRGBA` is enabled, and this mode will always succeed in
encoding an image. If `encRGBA` is disabled, the encoder might throw an error
if the image given is not encodable using any of the enabled colour types.
   */
  public var encodeColourTypes(default, null) = {
       encL:    false
      ,encRGB:  false
      ,encI:    false
      ,encIA:   false
      ,encLA:   false
      ,encRGBA: true
    };
  
  public function new(){}
  
  public function encode(obj:Bitmap):Bytes {
    var encL    = encodeColourTypes.encL;
    var encRGB  = encodeColourTypes.encRGB;
    var encI    = encodeColourTypes.encI;
    var encIA   = encodeColourTypes.encIA;
    var encLA   = encodeColourTypes.encLA;
    var encRGBA = encodeColourTypes.encRGBA;
    var enc
      = (encL    ? 1 : 0)
      + (encRGB  ? 1 : 0)
      + (encI    ? 1 : 0)
      + (encIA   ? 1 : 0)
      + (encLA   ? 1 : 0)
      + (encRGBA ? 1 : 0);
    
    if (enc == 0){
      throw "no possible colour type";
    }
    
    // indexed images
    var encIDepth       = 0;
    var encIColours     = 0;
    var encIAColours    = 0;
    var encIPalette     = new Vector<Colour>(256);
    var encIAPalette    = new Vector<Colour>(256);
    var encIPaletteMap  = new Map<Colour, Int>();
    var encIAPaletteMap = new Map<Colour, Int>();
    var encIFColours    = 0;
    var encIFPalette    = new Vector<Colour>(256);
    var encIFPaletteMap = new Map<Colour, Int>();
    
    // grayscale images
    var encLDepth = 1;
    
    var vec = obj.getVector();
    
    if (enc > 1 || encI || encIA){
      for (i in 0...vec.length){
        var a = vec[i].ai;
        var r = vec[i].ri;
        var g = vec[i].gi;
        var b = vec[i].bi;
        if (a != 0xFF){
          if (encL){
            encL = false;
            enc--;
          }
          if (encI){
            encI = false;
            enc--;
          }
          if (encRGB){
            encRGB = false;
            enc--;
          }
          encLDepth = 8;
        }
        if (encL || encLA){
          if (r != g || r != b){
            if (encL){
              encL = false;
              enc--;
            }
            if (encLA){
              encLA = false;
              enc--;
            }
          } else if (encLDepth < 8){
            encLDepth = FM.maxI(encLDepth, encodeLMinDepth[r]);
          }
        }
        if (encI || encIA){
          if (!encIPaletteMap.exists(vec[i])){
            if (encIFColours >= 256){
              if (encI){
                encI = false;
                enc--;
              }
              if (encIA){
                encIA = false;
                enc--;
              }
            } else {
              if (vec[i].ai != 0xFF){
                encIAPalette[encIAColours] = vec[i];
                encIAPaletteMap.set(vec[i], encIAColours);
                encIAColours++;
                encIFColours++;
              } else {
                encIPalette[encIColours] = vec[i];
                encIPaletteMap.set(vec[i], encIColours);
                encIColours++;
                encIFColours++;
              }
            }
          }
        }
        if (enc < 2 && !encI && !encIA){
          break;
        }
      }
    }
    
    var raw:Bytes = null;
    var rawPos = 0;
    var colourType = (if ((encL || encLA) && encLDepth == 8){
        for (i in 0...vec.length){
          if (i % obj.width == 0){
            raw.set(rawPos++, 0); // no filter (TODO)
          }
          raw.set(rawPos++, vec[i].ri);
          if (!encL){
            raw.set(rawPos++, vec[i].ai);
          }
        }
        if (!encL){
          4;
        } else {
          0;
        }
      } else if (encL || encLA){
        raw = Bytes.alloc(
            obj.height
              * (1 + ((obj.width * (!encL ? 2 : 1) * encLDepth + 7) >> 3))
          );
        var bsh = (8 - encLDepth);
        var bi:Int = 0;
        var cb:Int = 0;
        for (i in 0...vec.length){
          if (i % obj.width == 0){
            if (bi != 0){
              raw.set(rawPos++, cb);
            }
            raw.set(rawPos++, 0); // no filter (TODO)
            bi = 0;
            cb = 0;
          }
          cb |= (vec[i].ri >> bsh) << (8 - bi - encLDepth);
          bi += encLDepth;
          if (!encL){
            cb |= (vec[i].ai >> bsh) << (8 - bi - encLDepth);
            bi += encLDepth;
          }
          if (bi >= 8){
            raw.set(rawPos++, cb);
            bi = 0;
            cb = 0;
          }
        }
        if (bi != 0){
          raw.set(rawPos++, cb);
        }
        if (!encL){
          4;
        } else {
          0;
        }
      } else if (encI || encIA){
        for (i in 0...encIAColours){
          encIFPalette[i] = encIAPalette[i];
          encIFPaletteMap.set(encIFPalette[i], i);
        }
        for (i in 0...encIColours){
          encIFPalette[i + encIAColours] = encIPalette[i];
          encIFPaletteMap.set(encIFPalette[i + encIAColours], i + encIAColours);
        }
        
        encIDepth = (if (encIFColours <= 2){
            1;
          } else if (encIFColours <= 4){
            2;
          } else if (encIFColours <= 16){
            4;
          } else {
            8;
          });
        
        raw = Bytes.alloc(
            obj.height * (1 + ((obj.width * encIDepth + 7) >> 3))
          );
        var bi:Int = 0;
        var cb:Int = 0;
        for (i in 0...vec.length){
          if (i % obj.width == 0){
            if (bi != 0){
              raw.set(rawPos++, cb);
            }
            raw.set(rawPos++, 0); // no filter (TODO)
            bi = 0;
            cb = 0;
          }
          cb |= encIFPaletteMap.get(vec[i]) << (8 - bi - encIDepth);
          bi += encIDepth;
          if (bi >= 8){
            raw.set(rawPos++, cb);
            bi = 0;
            cb = 0;
          }
        }
        if (bi != 0){
          raw.set(rawPos++, cb);
        }
        3;
      } else if (encRGB){
        raw = Bytes.alloc(obj.height * (1 + (obj.width * 3)));
        for (i in 0...vec.length){
          if (i % obj.width == 0){
            raw.set(rawPos++, 0); // no filter (TODO)
          }
          raw.set(rawPos++, vec[i].ri);
          raw.set(rawPos++, vec[i].gi);
          raw.set(rawPos++, vec[i].bi);
        }
        2;
      } else if (encRGBA){
        raw = Bytes.alloc(obj.height * (1 + (obj.width << 2)));
        for (i in 0...vec.length){
          if (i % obj.width == 0){
            raw.set(rawPos++, 0); // no filter (TODO)
          }
          raw.writeLEInt32(rawPos, vec[i].rgba); rawPos += 4;
        }
        6;
      } else {
        throw "no possible colour type";
      });
    
    var compressed = Compress.run(raw, 5);
    
    var ret = Bytes.alloc(
          8 // signature
        + 25 // IHDR
        + (colourType == 3
          ? 12 // PLTE meta
          + encIFColours * 3 // PLTE data
          + (!encI
            ? 12 // tRNS meta
            + encIAColours // tRNS data
            : 0)
          : 0)
        + 12 // IDAT meta
        + compressed.length // IDAT data
        + 12 // IEND
      );
    var retPos = 0;
    
    // signature
    ret.writeLEInt32(retPos, 0x89504E47); retPos += 4; // '.PNG'
    ret.writeLEInt32(retPos, 0x0D0A1A0A); retPos += 4; // '....'
    
    // IHDR
    ret.writeLEInt32(retPos, 0x0000000D); retPos += 4; // IHDR size
    var chkPos = retPos;
    ret.writeLEInt32(retPos, 0x49484452); retPos += 4; // 'IHDR'
    ret.writeLEInt32(retPos, obj.width); retPos += 4; // width
    ret.writeLEInt32(retPos, obj.height); retPos += 4; // height
    ret.set(retPos++, (switch (colourType){
        case 0 | 4: encLDepth;
        case 3: encIDepth;
        case _: 8;
      })); // bpp / bits per colour channel
    ret.set(retPos++, colourType); // colour type
    ret.set(retPos++, 0x00); // compression mode / deflate
    ret.set(retPos++, 0x00); // filter mode / default
    ret.set(retPos++, 0x00); // interlace mode / none
    
    // IHDR CRC
    ret.writeLEInt32(retPos, CRC.calculateRange(ret, chkPos, 17)); retPos += 4;
    
    if (colourType == 3){
      // IPAL
      ret.writeLEInt32(retPos, encIColours * 3); retPos += 4; // PLTE size
      chkPos = retPos;
      ret.writeLEInt32(retPos, 0x504C5445); retPos += 4; // 'PLTE'
      
      for (i in 0...encIFColours){
        ret.set(retPos++, encIFPalette[i].ri);
        ret.set(retPos++, encIFPalette[i].gi);
        ret.set(retPos++, encIFPalette[i].bi);
      }
      
      // IPAL CRC
      ret.writeLEInt32(
          retPos, CRC.calculateRange(ret, chkPos, encIColours * 3 + 4)
        ); retPos += 4;
      
      if (encIAColours != 0){
        // tRNS
        ret.writeLEInt32(retPos, encIAColours); retPos += 4; // tRNS size
        chkPos = retPos;
        ret.writeLEInt32(retPos, 0x74524E53); retPos += 4; // 'tRNS'
        
        for (i in 0...encIAColours){
          ret.set(retPos++, encIAPalette[i].ai);
        }
        
        // tRNS CRC
        ret.writeLEInt32(
            retPos, CRC.calculateRange(ret, chkPos, encIAColours + 4)
          ); retPos += 4;
      }
    }
    
    // IDAT
    ret.writeLEInt32(retPos, compressed.length); retPos += 4; // IDAT size
    chkPos = retPos;
    ret.writeLEInt32(retPos, 0x49444154); retPos += 4; // 'IDAT'
    ret.blit(
        retPos, compressed, 0, compressed.length
      ); retPos += compressed.length;
    
    // IDAT CRC
    ret.writeLEInt32(
        retPos, CRC.calculateRange(ret, chkPos, compressed.length + 4)
      ); retPos += 4;
    
    // IEND
    ret.writeLEInt32(retPos, 0x00000000); retPos += 4; // IEND size
    ret.writeLEInt32(retPos, 0x49454E44); retPos += 4; // 'IEND'
    ret.writeLEInt32(retPos, 0xAE426082); retPos += 4; // IEND CRC
    
    return ret;
  }
  
  public function decode(data:Bytes):Bitmap {
    var datPos = 0;
    
    // check signature
    if (data.readLEInt32(datPos) != 0x89504E47){
      throw "incorrect header";
    }
    datPos += 4;
    if (data.readLEInt32(datPos) != 0x0D0A1A0A){
      throw "incorrect header";
    }
    datPos += 4;
    
    var ihdrSize = data.readLEInt32(datPos); datPos += 4;
    var chkPos = datPos;
    if (data.readLEInt32(datPos) != 0x49484452){
      throw "missing IHDR chunk";
    }
    datPos += 4;
    
    var retWidth = data.readLEInt32(datPos); datPos += 4;
    if (retWidth <= 0 || retWidth > 2048){
      throw "image width incorrect";
    }
    var retHeight = data.readLEInt32(datPos); datPos += 4;
    if (retHeight <= 0 || retHeight > 2048){
      throw "image height incorrect";
    }
    var retBpp = data.get(datPos++);
    var retColour = data.get(datPos++);
    if (switch (retColour){
        case 0: // grayscale
        (retBpp != 1 && retBpp != 2
          && retBpp != 4 && retBpp != 8 && retBpp != 16);
        case 3: // indexed
        (retBpp != 1 && retBpp != 2
          && retBpp != 4 && retBpp != 8);
        case 2 // truecolour
           | 4 // grayscale and alpha
           | 6: // truecolour and alpha
        (retBpp != 8 && retBpp != 16);
        case _:
        throw "invalid colour mode";
      }){
      throw "invalid bit depth";
    }
    if (retColour != 6 && retColour != 2){
      throw "unsupported colour mode";
    }
    
    var pixelBytes = (switch (retColour){
        case 2: 3;
        case 6: 4;
        case _: 0;
      });
    
    var retCompress  = data.get(datPos++);
    var retFilter    = data.get(datPos++);
    var retInterlace = data.get(datPos++);
    
    if (CRC.calculateRange(data, chkPos, 17)
        != (cast data.readLEInt32(datPos):UInt)){
      throw "incorrect IHDR CRC";
    }
    datPos += 4;
    
    var chunkCountsMax = [
        "tIMe" => 1,
        "zTXt" => -1,
        "tEXt" => -1,
        "iTXt" => -1,
        "pHYs" => 1,
        "sPLT" => -1,
        "iCCP" => 1,
        "sRGB" => 1,
        "sBIT" => 1,
        "gAMA" => 1,
        "cHRM" => 1,
        "PLTE" => 1,
        "tRNS" => 1,
        "hIST" => 1,
        "bKGD" => 1
      ];
    var chunkCounts = [
        "tIMe" => 0,
        "zTXt" => 0,
        "tEXt" => 0,
        "iTXt" => 0,
        "pHYs" => 0,
        "sPLT" => 0,
        "iCCP" => 0,
        "sRGB" => 0,
        "sBIT" => 0,
        "gAMA" => 0,
        "cHRM" => 0,
        "PLTE" => 0,
        "tRNS" => 0,
        "hIST" => 0,
        "bKGD" => 0
      ];
    
    var iend      = false;
    var idatFirst = false;
    var idatEnd   = false;
    var idatBytesStarts:Array<UInt> = [];
    var idatBytesEnds:Array<UInt>   = [];
    
    var retWidthBytes = retWidth * pixelBytes;
    var ret = Platform.createBitmap(retWidth, retHeight, 0);
    
    while (datPos < data.length){
      var chkSize = data.readLEInt32(datPos);
      datPos += 4;
      chkPos = datPos;
      var chkType = data.getString(datPos, 4);
      datPos += 4;
      if (idatFirst && !idatEnd && chkType != "IDAT"){
        idatEnd = true;
        var cdlen = 0;
        for (i in 0...idatBytesStarts.length){
          cdlen += idatBytesEnds[i] - idatBytesStarts[i];
        }
        var compressed = Bytes.alloc(cdlen);
        for (i in 0...idatBytesStarts.length){
          compressed.blit(
              0, data, idatBytesStarts[i], idatBytesEnds[i] - idatBytesStarts[i]
            );
        }
        var udata = Uncompress.run(compressed);
        var upos  = 0;
        
        var fdata = Bytes.alloc(udata.length - retHeight);
        var fpos = 0;
        for (y in 0...retHeight){
          var filter = udata.get(upos++);
          switch (filter){ // truecolour and alpha
            case 0: // no filter
            fdata.blit(fpos, udata, upos, retWidthBytes);
            fpos += retWidthBytes;
            upos += retWidthBytes;
            
            case 1: // sub
            for (x in 0...retWidthBytes){
              var a:UInt = (x >= pixelBytes ? fdata.get(fpos - pixelBytes) : 0);
              var p:UInt = udata.get(upos++);
              fdata.set(fpos++, (p + a) & 0xFF);
            }
            
            case 2: // up
            for (x in 0...retWidthBytes){
              var b:UInt = (y > 0 ? fdata.get(fpos - retWidthBytes) : 0);
              var p:UInt = udata.get(upos++);
              fdata.set(fpos++, (p + b) & 0xFF);
            }
            
            case 3: // average
            for (x in 0...retWidthBytes){
              var a:UInt = (x >= pixelBytes ? fdata.get(fpos - pixelBytes) : 0);
              var b:UInt = (y > 0 ? fdata.get(fpos - retWidthBytes) : 0);
              var p:UInt = udata.get(upos++);
              fdata.set(fpos++, (p + ((a + b) >> 1)) & 0xFF);
            }
            
            case 4: // paeth
            for (x in 0...retWidthBytes){
              var a:UInt = (x >= pixelBytes ? fdata.get(fpos - pixelBytes) : 0);
              var b:UInt = (y > 0 ? fdata.get(fpos - retWidthBytes) : 0);
              var c:UInt = (x >= pixelBytes && y > 0 ? fdata.get(fpos - pixelBytes - retWidthBytes) : 0);
              var p:UInt = udata.get(upos++);
              var paeth:UInt = a + b - c;
              var paethDa:UInt = FM.absI(paeth - a);
              var paethDb:UInt = FM.absI(paeth - b);
              var paethDc:UInt = FM.absI(paeth - c);
              fdata.set(fpos++, (p + (if (paethDa <= paethDb && paethDa <= paethDc){
                  a;
                } else if (paethDb <= paethDc){
                  b;
                } else {
                  c;
                })) & 0xFF);
            }
            
            case _:
            throw "unsupported line filter " + filter;
          }
        }
        
        fpos = 0;
        var vec = new Vector<Colour>(retWidth * retHeight);
        var vi:Int = 0;
        switch (retColour){
          case 2: // truecolour
          for (y in 0...retHeight) for (x in 0...retWidth){
            vec[vi++] = 0xFF000000
              | (fdata.get(fpos++) << 16)
              | (fdata.get(fpos++) << 8)
              | fdata.get(fpos++);
          }
          
          case 6: // truecolour and alpha
          for (y in 0...retHeight) for (x in 0...retWidth){
            var p:UInt = fdata.readLEInt32(fpos); fpos += 4;
            vec[vi++] = (p << 24) | (p >>> 8);
          }
        }
        ret.setVector(vec);
      }
      switch (chkType){
        case "IHDR": throw "IHDR twice";
        case "IDAT":
        if (idatEnd){
          throw "non-consecutive IDAT chunks";
        }
        idatFirst = true;
        idatBytesStarts.push(datPos);
        idatBytesEnds.push(datPos + chkSize);
        case "IEND":
        if (chkSize != 0){
          throw "IEND with data";
        }
        iend = true;
        case _:
        if (!chunkCountsMax.exists(chkType)){
          throw "unknown chunk type";
        }
        chunkCounts.set(chkType, chunkCounts.get(chkType) + 1);
        if (chunkCountsMax.get(chkType) != -1
            && chunkCounts.get(chkType) > chunkCountsMax.get(chkType)){
          throw "too many ancillary chunks";
        }
      }
      datPos += chkSize;
      if (CRC.calculateRange(data, chkPos, chkSize + 4)
          != (cast data.readLEInt32(datPos):UInt)){
        throw "incorrect CRC";
      }
      datPos += 4;
      if (iend && datPos < data.length){
        throw "data after IEND";
      }
    }
    
    if (!iend){
      throw "no IEND";
    }
    if (!idatEnd){
      throw "no IDAT";
    }
    
    return ret;
  }
}
