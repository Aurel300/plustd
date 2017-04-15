package sk.thenet.net.http;

import haxe.io.Bytes;

/**
##HTTP - Tools##

This class defines some tools for working with the HTTP/1.1 protocol.
 */
class Tools {
  public static function createRequest(
    url:String, method:Method, headers:Map<String, String>, ?data:Bytes
  ):Bytes {
    var buf = new StringBuf();
    buf.add((switch (method){
        case GET: "GET";
        case POST: "POST";
      }));
    buf.add(" ");
    buf.add(url);
    buf.add(" HTTP/1.1");
    for (key in headers.keys()){
      buf.add("\r\n");
      buf.add(key);
      buf.add(": ");
      buf.add(headers.get(key));
    }
    buf.add("\r\n\r\n");
    return Bytes.ofString(buf.toString());
  }
}
