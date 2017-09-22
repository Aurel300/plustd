package sk.thenet.graph;

import sk.thenet.ds.DynamicVector;
import sk.thenet.ds.Pair;
import sk.thenet.stream.Stream;

using sk.thenet.stream.Stream;

/**
##A* pathfinding##
 */
class AStar {
  /**
Finds a path from `a` to `b` using A*.

@param a Starting point.
@param b Target point.
@param heuristic Heuristic distance between a point and the target. Should be
  inexpensive.
@param cost Cost function.
@param neighbours Function to return all neighbours of the given point. Should
  always return the same object when referring to the same point.
@return An array of visited nodes, including `a` and `b`. If no path is found,
  `null` is returned.
   */
  public static function path<T>(
    a:T, b:T, heuristic:T->Float, cost:T->T->Float, neighbours:T->Array<T>
  ):Array<T> {
    // *E - objects (of type T)
    // *C - best cost to get to the object
    // *F - best origin
    // *H - heuristic distance from goal
    var visitedE = [a];
    var visitedC = [0.0];
    var visitedF = [-1];
    var queueE   = neighbours(a);
    var queueC   = [ for (q in queueE) cost(a, q) ];
    var queueF   = [ for (q in queueE) 0 ];
    var queueH   = queueE.map(heuristic);
    while (queueE.length > 0) {
      var pI = 0; //queueH.streamArray().minIdx(Stream.id);
      var mcost = queueH[0];
      for (i in 1...queueH.length) {
        if (queueH[i] < mcost) {
          mcost = queueH[i];
          pI = i;
        }
      }
      var pE = queueE.splice(pI, 1)[0];
      var pC = queueC.splice(pI, 1)[0];
      var pF = queueF.splice(pI, 1)[0];
               queueH.splice(pI, 1);
      if (pE == b) {
        var retE = [pE];
        var retI = pF;
        while (retI != -1) {
          retE.unshift(visitedE[retI]);
          retI = visitedF[retI];
        }
        return retE;
      }
      pI = visitedE.indexOf(pE);
      if (pI == -1) {
        for (nE in neighbours(pE)) {
          var nC = pC + cost(pE, nE);
          queueE.push(nE);
          queueC.push(nC);
          queueF.push(visitedE.length);
          queueH.push(heuristic(nE) + nC);
        }
        visitedE.push(pE);
        visitedC.push(pC);
        visitedF.push(pF);
      } else if (visitedC[pI] > pC) {
        visitedC[pI] = pC;
        visitedF[pI] = pF;
      }
    }
    return null;
  }
}
