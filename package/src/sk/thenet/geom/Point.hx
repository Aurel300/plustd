package sk.thenet.geom;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

using StringTools;

/**
##N-dimensional points##

This is a macro class which will generate N-dimensional integer or floating
point classes on demand. It supports any number of dimensions between 1 and 9,
inclusive. To use this functionality, simply use any of the
`sk.thenet.geom.Point[1-9]D[FI]` classes. The 2D and 3D variants are included
in the documentation to serve as API reference. Points with higher dimensions
all have the same API.

There are two types of operations on points:

 - Cloning - These create a new instance of the point that is the result of
applying the given operation. Suffixed with `C`.
 - Modifying - These modify the instance of the point. Suffixed with `M`.

@see `Point2DF`
@see `Point2DI`
@see `Point3DF`
@see `Point3DI`
 */
class Point {
  /**
The identifiers used for point dimensions.
   */
  public static var DIMS = ["x", "y", "z", "w", "d5", "d6", "d7", "d8", "d9"];
  
  /**
Interpolates a point with another point linearly. Always returns a new point
with the same dimension as the two given points and `Float` coordinates.

Note when using this with quaternions: This does not guarantee unit length.
To use the result as a versor, it should first be normalised using `unitM()`.
   */
  public static macro function interpolate(
    pt1:Expr, pt2:Expr, ratio:ExprOf<Float>
  ):Expr {
    var f1 = getExprType(pt1);
    var f2 = getExprType(pt2);
    if (f1.dim != f2.dim) {
      throw "point type mismatch";
    }
    var toname = "sk.thenet.geom.Point" + f1.dim + "DF";
    return macro $b{[
           macro (var inp1 = $pt1)
          ,macro (var inp2 = $pt2)
          ,macro (var r = $ratio)
          ,Context.parse('{ new $toname(' + [
              for (i in 0...f1.dim) 'inp1.${DIMS[i]} * (1 - r) + inp2.${DIMS[i]} * r'
            ].join(", ") + '); }', Context.currentPos())
        ]};
  }
  
  /**
Projects a point to the given number of dimensions (`to`). If the target
dimension is higher, the missing dimensions are filled with zeroes. If the
target dimension is lower, the dimensions are truncated. This is ideally used
as a static extension:

```haxe
    using sk.thenet.geom.Point;
```

```haxe
    var a = new Point2DI(1, 2);
    a.project(1); // -> Point1DI(1)
    a.project(3); // -> Point3DI(1, 2, 0)
    
```
   */
  public static macro function project(pt:Expr, to:Int):Expr {
    var from = getExprType(pt);
    var toname = "sk.thenet.geom.Point" + to + "D" + (from.isInt ? "I" : "F");
    return macro $b{[
           macro (var inp = $pt)
          ,Context.parse('{ new $toname(' + [
              for (i in 0...to) (i < from.dim ? 'inp.${DIMS[i]}' : "0")
            ].join(", ") + '); }', Context.currentPos())
        ]};
  }
  
  public static function isPointClass(gp:String):Bool {
    return (gp.startsWith("Point")
        && (gp.endsWith("DF") || gp.endsWith("DI"))
        && gp.length == 8
        && gp.charCodeAt(5) >= "1".code
        && gp.charCodeAt(5) <= "9".code);
  }
  
#if macro
  private static function getExprType(pt:Expr):{dim:Int, isInt:Bool} {
    switch (Context.typeof(pt)) {
      case TInst(clsRef, _):
      var cls = clsRef.get();
      switch [cls.pack, cls.name] {
        case [["sk", "thenet", "geom"], gp]:
        if (!isPointClass(gp)) {
          throw "not a point";
        }
        return {dim: gp.charCodeAt(5) - "0".code, isInt: gp.endsWith("DI")};
        
        case _: throw "not a point";
      }
      
      case _: throw "not a point";
    }
  }
  
  public static function buildPoint(dim:Int, isInt:Bool):TypeDefinition {
    var iname = "Point" + dim + "DI";
    var itype = TPath({name: iname, pack: ["sk", "thenet", "geom"], params: []});
    var fname = "Point" + dim + "DF";
    var ftype = TPath({name: fname, pack: ["sk", "thenet", "geom"], params: []});
    var cname = isInt ? iname : fname;
    var ctype = isInt ? itype : ftype;
    var pos = Context.currentPos();
    var coordType = isInt ? (macro : Int) : (macro : Float);
    
    // coordinates
    var fields:Array<Field> = [ for (i in 0...dim) {
         access: [APublic]
        ,doc: 'Coordinate #${i + 1}.'
        ,kind: FVar(coordType, null)
        ,meta: []
        ,name: DIMS[i]
        ,pos: pos
      } ];
    
    function addProperty(
      name:String, type:ComplexType, expr:Expr, doc:String
    ):Void {
      fields.push({
           access: [APublic]
          ,doc: doc
          ,kind: FProp("get", "never", type, null)
          ,meta: []
          ,name: name
          ,pos: pos
        });
      fields.push({
           access: [AInline, APrivate]
          ,doc: null
          ,kind: FFun({
               args: []
              ,expr: expr
              ,params: []
              ,ret: type
            })
          ,meta: []
          ,name: "get_" + name
          ,pos: pos
        });
    }
    
    addProperty("magnitude", macro : Float, Context.parse("{ return Math.sqrt(" + [
        for (i in 0...dim) DIMS[i] + " * " + DIMS[i]
      ].join(" + ") + "); }", pos), "Magnitude of this point.");
    addProperty("componentSum", coordType, Context.parse("{ return " + [
        for (i in 0...dim) DIMS[i]
      ].join(" + ") + "; }", pos), "The sum of the coordinates of this point.");
    
    function addFunction(
       name:String, args:Array<{name:String, type: ComplexType}>
      ,ret:ComplexType, expr:Expr, doc:String
    ):Void {
      fields.push({
           access: [AInline, APublic]
          ,doc: doc
          ,kind: FFun({
               args: [ for (a in args) {
                    meta: []
                   ,name: a.name
                   ,type: a.type
                   ,opt: false
                   ,value: null
                 } ]
              ,expr: expr
              ,params: []
              ,ret: ret
            })
          ,meta: []
          ,name: name
          ,pos: pos
        });
    }
    
    // constructor
    addFunction(
         "new"
        ,[ for (i in 0...dim) { name: DIMS[i], type: coordType} ]
        ,null
        ,Context.parse("{ " + [
            for (i in 0...dim) 'this.${DIMS[i]} = ${DIMS[i]}'
          ].join("; ") + "; }", pos)
        ,dim + "-dimensional point with " + (isInt ? "integer" : "float")
          + " coordinates. Class generated at compile time on demand.\n\n"
          + "@see `sk.thenet.geom.Point`"
      );
    
    // clones
    addFunction(
         "clone"
        ,[]
        ,ctype
        ,Context.parse('{ return new ${cname}(' + [
            for (i in 0...dim) DIMS[i]
          ].join(", ") + "); }", pos)
        ,"@return A copy of this point."
      );
    if (isInt) {
      addFunction(
           "cloneF"
          ,[]
          ,ftype
          ,Context.parse('{ return new ${fname}(' + [
              for (i in 0...dim) DIMS[i]
            ].join(", ") + "); }", pos)
          ,"@return A copy of this point, with float coordinates."
        );
    } else {
      addFunction(
           "cloneI"
          ,[]
          ,itype
          ,Context.parse('{ return new ${iname}(' + [
              for (i in 0...dim) 'sk.thenet.FM.floor(${DIMS[i]})'
            ].join(", ") + "); }", pos)
          ,"@return A copy of this point, with floored integer coordinates."
        );
    }
    
    // operations with other points
    addFunction(
         "distance"
        ,[{name: "other", type: ctype}]
        ,macro : Float
        ,Context.parse("{ " + [
            for (i in 0...dim) 'var d${DIMS[i]} = ${DIMS[i]} - other.${DIMS[i]}'
          ].join("; ") + "; return Math.sqrt(" + [
            for (i in 0...dim) 'd${DIMS[i]} * d${DIMS[i]}'
          ].join(" + ") + "); }", pos)
        ,"@return Distance from `other`."
      );
    addFunction(
         "distanceManhattan"
        ,[{name: "other", type: ctype}]
        ,coordType
        ,Context.parse("{ return " + [
            for (i in 0...dim) 'sk.thenet.FM.abs${isInt ? "I" : "F"}(${DIMS[i]} - other.${DIMS[i]})'
          ].join(" + ") + "; }", pos)
        ,"@return Manhattan (component-wise) distance from `other`."
      );
    addFunction(
         "dot"
        ,[{name: "other", type: ctype}]
        ,coordType
        ,Context.parse("{ return " + [
            for (i in 0...dim) '${DIMS[i]} * other.${DIMS[i]}'
          ].join(" + ") + "; }", pos)
        ,"@return Result of the dot product of this point with `other`."
      );
    addFunction(
         "angle"
        ,[{name: "other", type: ctype}]
        ,macro : Float
        ,macro { return Math.acos(dot(other) / (magnitude * other.magnitude)); }
        ,"@return Angle between this point and `other` (as vectors)."
      );
    if (dim == 3) {
      addFunction(
           "cross"
          ,[{name: "other", type: ctype}]
          ,ctype
          ,Context.parse('{ return new ${cname}(' + [ for (i in 0...dim)
              '${DIMS[(i + 1) % 3]} * other.${DIMS[(i + 2) % 3]} '
                + '- ${DIMS[(i + 2) % 3]} * other.${DIMS[(i + 1) % 3]}'
            ].join(", ") + "); }", pos)
          ,"@return Result of the cross product of this point with `other`. "
            + "Only defined for 3-dimensional points."
        );
    }
    
    function addFunctionCM(
       name:String, args:Array<{name:String, type:ComplexType}>
      ,dimF:String->String, docC:String, docM:String
    ):Void {
      addFunction(
           name + "C"
          ,args
          ,ctype
          ,Context.parse('{ return new ${cname}(' + [
              for (i in 0...dim) dimF(DIMS[i])
            ].join(", ") + "); }", pos)
          ,docC
        );
      addFunction(
           name + "M"
          ,args
          ,ctype
          ,Context.parse("{ " + [
              for (i in 0...dim) '${DIMS[i]} = ' + dimF(DIMS[i]) + ";"
            ].join(" ") + " return this; }", pos)
          ,docM + "\n\n@return This point after modification."
        );
    }
    
    // clone / modify operations
    addFunctionCM(
         "absolute", []
        ,function(dim) return 'sk.thenet.FM.abs${isInt ? "I" : "F"}($dim)'
        ,"@return A point whose coordinates are the absolute values of the "
          + "coordinates of this point."
        ,"Make the coordinates of this point positive."
      );
    addFunctionCM(
         "add", [{name: "other", type: ctype}]
        ,function(dim) return '$dim + other.$dim'
        ,"@return Result of adding `other` point to this one."
        ,"Adds `other` to this point."
      );
    addFunctionCM(
         "multiply", [{name: "other", type: ctype}]
        ,function(dim) return '$dim * other.$dim'
        ,"@return Result of a component-wise multiplication of this point "
          + "and `other`."
        ,"Component-wise multiplies this point and `other`."
      );
    addFunctionCM(
         "negate", []
        ,function(dim) return '-$dim'
        ,"@return A copy of this point, with the signs of its coordinates "
          + "flipped."
        ,"Changes the signs of the coordinates of this point."
      );
    addFunctionCM(
         "scale", [{name: "scale", type: coordType}]
        ,function(dim) return '$dim * scale'
        ,"@return Result of scaling this point by a scalar `factor`."
        ,"Scales this point by a scalar `factor`."
      );
    addFunctionCM(
         "subtract", [{name: "other", type: ctype}]
        ,function(dim) return '$dim - other.$dim'
        ,"@return Result of subtracting `other` point from this one."
        ,"Subtracts `other` point from this one."
      );
    if (!isInt) {
      addFunction(
           "unitC"
          ,[]
          ,ctype
          ,Context.parse("{ return scaleC(1 / magnitude); }", pos)
          ,"@return A point with the same direction as this one, but its "
            + "length equal to 1."
        );
      addFunction(
           "unitM"
          ,[]
          ,null
          ,Context.parse("{ scaleM(1 / magnitude); return this; }", pos)
          ,"Scales this point so that its length is 1."
            + "\n\n@return This point after modification."
        );
    }
    
    // toString
    addFunction(
         "toString"
        ,[]
        ,macro : String
        ,Context.parse("{ return '(' + " + [
            for (i in 0...dim) DIMS[i]
          ].join(" + ', ' + ") + " + ')'; }", pos)
        ,"@return The string representation of this point."
      );
    
    return {
         fields: fields
        ,isExtern: false
        ,kind: TDClass(null, [], false)
        ,meta: []
        ,name: cname
        ,pack: ["sk", "thenet", "geom"]
        ,params: []
        ,pos: pos
      };
  }
#end
}
