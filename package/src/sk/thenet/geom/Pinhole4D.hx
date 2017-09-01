package sk.thenet.geom;

/**
##4D-to-3D pinhole camera##

This is a 4D equivalent of `Pinhole3D`. It works analogously to the simpler
model – the last coordinate (`w`) of the point is used to estimate the
perspective scaling. The result of a projection is a 3D point. Another pinhole
camera (potentially with a different focal length) can then be used to project
to 2D.

@see `Pinhole3D`
 */
class Pinhole4D {
  /**
Focal length of the camera. The "units" of this length are the same as those
of the coordinates passed in to `project`.
   */
  public var focalLength:Float;
  
  public function new(focalLength:Float) {
    this.focalLength = focalLength;
  }
  
  /**
Projects the given `point` onto the screen and returns the projected image.
   */
  public function project(point:Point4DF):Point3DF {
    var t = focalLength / point.w;
    return new Point3DF(t * point.x, t * point.y, t * point.z);
  }
}
