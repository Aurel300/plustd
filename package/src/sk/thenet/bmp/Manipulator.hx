package sk.thenet.bmp;

import sk.thenet.bmp.Bitmap;

/**
##Bitmap manipulator##

Base class for bitmap manipulators.

Please note these can only be used for very simple image processing, and even
then the performance will be rather bad - use these in pre-processing, as
asset binds, for example.

(TODO: GLSL shader manipulators which should be comparatively very fast.)

@see `FluentBitmap` for description of extraction and manipulation operations.
 */
class Manipulator {
  public function extract(bitmap:Bitmap):Bitmap {
    return null;
  }
  
  public function manipulate(bitmap:Bitmap):Void {}
}
