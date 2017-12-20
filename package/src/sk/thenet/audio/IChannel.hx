package sk.thenet.audio;

interface IChannel {
  public function setVolume(vol:Float):Void;
  public function setPan(pan:Float):Void;
  public function stop():Void;
}
