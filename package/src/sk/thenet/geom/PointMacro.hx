package sk.thenet.geom;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

class PointMacro {
  public static function buildPoint(dim:Int, isInt:Bool):TypeDefinition {
    var cname = "Point" + dim + "D" + (isInt ? "I" : "F");
    var ctype = TPath({name: cname, pack: ["sk", "thenet", "geom"], params: []});
    var dims = ["x", "y", "z", "w", "d5", "d6", "d7", "d8", "d9"];
    var pos = Context.currentPos();
    var intType = TPath({name: "Int", pack: [], params: []});
    var floatType = TPath({name: "Float", pack: [], params: []});
    var stringType = TPath({name: "String", pack: [], params: []});
    var coordType = isInt ? intType : floatType;
    
    // coordinates
    var fields:Array<Field> = [ for (i in 0...dim) {
         access: [APublic]
        ,doc: 'Coordinate #${i + 1}.'
        ,kind: FVar(coordType, null)
        ,meta: []
        ,name: dims[i]
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
    
    addProperty("magnitude", floatType, Context.parse("{ return Math.sqrt(" + [
        for (i in 0...dim) dims[i] + " * " + dims[i]
      ].join(" + ") + "); }", pos), "Magnitude of this point.");
    addProperty("componentSum", coordType, Context.parse("{ return " + [
        for (i in 0...dim) dims[i]
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
        ,[ for (i in 0...dim) { name: dims[i], type: coordType} ]
        ,null
        ,Context.parse("{ " + [
            for (i in 0...dim) 'this.${dims[i]} = ${dims[i]}'
          ].join("; ") + "; }", pos)
        ,dim + "-dimensional point with " + (isInt ? "integer" : "float")
          + " coordinates. Class generated at compile time on demand.\n\n"
          + "@see sk.thenet.geom.PointMacro"
      );
    
    // clones
    addFunction(
         "clone"
        ,[]
        ,ctype
        ,Context.parse('{ return new ${cname}(' + [
            for (i in 0...dim) dims[i]
          ].join(", ") + "); }", pos)
        ,"@return A copy of this point."
      );
    
    // operations with other points
    addFunction(
         "distance"
        ,[{name: "other", type: ctype}]
        ,floatType
        ,Context.parse("{ " + [
            for (i in 0...dim) 'var d${dims[i]} = ${dims[i]} - other.${dims[i]}'
          ].join("; ") + "; return Math.sqrt(" + [
            for (i in 0...dim) 'd${dims[i]} * d${dims[i]}'
          ].join(" + ") + "); }", pos)
        ,"@return Distance from `other`."
      );
    addFunction(
         "distanceManhattan"
        ,[{name: "other", type: ctype}]
        ,coordType
        ,Context.parse("{ return " + [
            for (i in 0...dim) 'sk.thenet.FM.abs${isInt ? "I" : "F"}(${dims[i]} - other.${dims[i]})'
          ].join(" + ") + "; }", pos)
        ,"@return Manhattan (component-wise) distance from `other`."
      );
    addFunction(
         "dot"
        ,[{name: "other", type: ctype}]
        ,coordType
        ,Context.parse("{ return " + [
            for (i in 0...dim) '${dims[i]} * other.${dims[i]}'
          ].join(" + ") + "; }", pos)
        ,"@return Result of the dot product of this point with `other`."
      );
    
    // clone / modify operations
    addFunction(
         "absoluteC"
        ,[]
        ,ctype
        ,Context.parse('{ return new ${cname}(' + [
            for (i in 0...dim) 'sk.thenet.FM.abs${isInt ? "I" : "F"}(${dims[i]})'
          ].join(", ") + "); }", pos)
        ,"@return A point whose coordinates are the absolute values of the "
          + "coordinates of this point."
      );
    addFunction(
         "absoluteM"
        ,[]
        ,null
        ,Context.parse("{ " + [
            for (i in 0...dim) '${dims[i]} *= sk.thenet.FM.abs${isInt ? "I" : "F"}(${dims[i]});'
          ].join(" ") + " }", pos)
        ,"Make the coordinates of this point positive."
      );
    addFunction(
         "addC"
        ,[{name: "other", type: ctype}]
        ,ctype
        ,Context.parse('{ return new ${cname}(' + [
            for (i in 0...dim) '${dims[i]} + other.${dims[i]}'
          ].join(", ") + "); }", pos)
        ,"@return Result of adding `other` point to this one."
      );
    addFunction(
         "addM"
        ,[{name: "other", type: ctype}]
        ,null
        ,Context.parse("{ " + [
            for (i in 0...dim) '${dims[i]} += other.${dims[i]};'
          ].join(" ") + " }", pos)
        ,"Adds `other` to this point."
      );
    addFunction(
         "multiplyC"
        ,[{name: "other", type: ctype}]
        ,ctype
        ,Context.parse('{ return new ${cname}(' + [
            for (i in 0...dim) '${dims[i]} * other.${dims[i]}'
          ].join(", ") + "); }", pos)
        ,"@return Result of a component-wise multiplication of this point "
          + "and `other`."
      );
    addFunction(
         "multiplyM"
        ,[{name: "other", type: ctype}]
        ,null
        ,Context.parse("{ " + [
            for (i in 0...dim) '${dims[i]} *= other.${dims[i]};'
          ].join(" ") + " }", pos)
        ,"Component-wise multiplies this point and `other`."
      );
    addFunction(
         "negateC"
        ,[]
        ,ctype
        ,Context.parse('{ return new ${cname}(' + [
            for (i in 0...dim) "-" + dims[i]
          ].join(", ") + "); }", pos)
        ,"@return A copy of this point, with the signs of its coordinates "
          + "flipped."
      );
    addFunction(
         "negateM"
        ,[]
        ,null
        ,Context.parse("{ " + [
            for (i in 0...dim) '${dims[i]} = -${dims[i]};'
          ].join(" ") + " }", pos)
        ,"Changes the signs of the coordinates of this point."
      );
    addFunction(
         "scaleC"
        ,[{name: "scale", type: coordType}]
        ,ctype
        ,Context.parse('{ return new ${cname}(' + [
            for (i in 0...dim) '${dims[i]} * scale'
          ].join(", ") + "); }", pos)
        ,"@return Result of scaling this point by a scalar `factor`."
      );
    addFunction(
         "scaleM"
        ,[{name: "scale", type: coordType}]
        ,null
        ,Context.parse("{ " + [
            for (i in 0...dim) '${dims[i]} *= scale;'
          ].join(" ") + " }", pos)
        ,"Scales this point by a scalar `factor`."
      );
    addFunction(
         "subtractC"
        ,[{name: "other", type: ctype}]
        ,ctype
        ,Context.parse('{ return new ${cname}(' + [
            for (i in 0...dim) '${dims[i]} - other.${dims[i]}'
          ].join(", ") + "); }", pos)
        ,"@return Result of subtracting `other` point from this one."
      );
    addFunction(
         "subtractM"
        ,[{name: "other", type: ctype}]
        ,null
        ,Context.parse("{ " + [
            for (i in 0...dim) '${dims[i]} -= other.${dims[i]};'
          ].join(" ") + " }", pos)
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
          ,Context.parse("{ scaleM(1 / magnitude); }", pos)
          ,"Scales this point so that its length is 1."
        );
    }
    
    // toString
    addFunction(
         "toString"
        ,[]
        ,stringType
        ,Context.parse("{ return '(' + " + [
            for (i in 0...dim) dims[i]
          ].join(" + ', ' + ") + " + ')'; }", pos)
        ,"@return The string representation of this point."
      );
    
    var ret = {
         fields: fields
        ,isExtern: false
        ,kind: TDClass(null, [], false)
        ,meta: []
        ,name: cname
        ,pack: ["sk", "thenet", "geom"]
        ,params: []
        ,pos: pos
      };
    return ret;
  }
}
#end
