package sk.thenet.stream;

/**
##Stream collector##

This interface defines a class which can collect the elements from a stream
into a different data structure.

@see `sk.thenet.stream.Collectors` for common collector implementations.
 */
interface Collector<T, U> {
  public function collect(s:Iterator<T>):U;
}
