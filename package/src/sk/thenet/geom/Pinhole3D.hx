package sk.thenet.geom;

/**
##Pinhole camera##

This represents a very simple camera model with a focal length `f` that
projects 3D points onto a 2D screen. The optical axis is the positive Z axis,
the pinhole itself lies on the origin `(0, 0, 0)`, and the screen is a plane at
`-f` on the Z axis.

For 3D rendering, the points should be transformed with the camera matrix to
ensure they are in the correct position. Any point with a negative Z should not
be rendered.
 */
class Pinhole3D {
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
  public function project(point:Point3DF):Point2DF {
    var t = focalLength / point.z;
    return new Point2DF(t * point.x, t * point.y);
  }
}
