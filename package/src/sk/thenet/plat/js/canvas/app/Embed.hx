package sk.thenet.plat.js.canvas.app;

#if js

import haxe.io.Bytes;
import js.Browser;
import js.html.Audio;
import js.html.CanvasElement;
import js.html.Image;
import js.html.XMLHttpRequest;
import sk.thenet.app.asset.Binary as AssetBinary;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.audio.Sound;
import sk.thenet.bmp.Bitmap;

/**
JavaScript / Canvas implementation of `sk.thenet.app.Embed`.

@see `sk.thenet.app.Embed`
 */
class Embed {
  public static function getBinary(id:String, file:String):AssetBinary {
    var ret = new AssetBinary(id, file);
    ret.preload = function():Void {
      var req = new XMLHttpRequest();
      req.addEventListener("load", function() {
        ret.update(Bytes.ofString(req.response));
      });
      req.open("GET", file);
      req.send();
    };
    return ret;
  }
  
  public static function getBitmap(id:String, file:String):AssetBitmap {
    var ret = new AssetBitmap(id, file);
    ret.preload = function():Void {
      var img = new Image();
      img.onload = function() {
        var canvas
          = (cast Browser.document.createElement("canvas"):CanvasElement);
        canvas.width = img.width;
        canvas.height = img.height;
        var c2d = canvas.getContext2d();
        c2d.drawImage(img, 0, 0);
        var bmp = new Bitmap(canvas, c2d);
        ret.updateBitmap(bmp);
      };
      img.src = file;
    };
    return ret;
  }
  
  public static function getSound(id:String, file:String):AssetSound {
    var ret = new AssetSound(id, file);
    ret.preload = function():Void {
      var audio = new Audio();
      audio.oncanplaythrough = function() {
        var sound = new Sound(audio);
        ret.updateSound(sound);
      };
      audio.src = file;
      audio.preload = "auto";
      audio.load();
      audio.volume = 0;
      audio.play();
    };
    return ret;
  }
}

#end
