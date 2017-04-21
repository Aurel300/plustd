package sk.thenet.geom;

/**
##2D Integer point + 1D Float coordinate##
 */
class Point2DI1DF extends Point2DI {
  public var v(default, null):Float;
  
  public inline function new(x:Int, y:Int, v:Float){
    super(x, y);
    this.v = v;
  }
}
