package sk.thenet.bmp.manip;

import haxe.macro.Context;
import haxe.macro.Expr;

class VectorManipulatorMacro {
  macro static public function build():Array<Field> {
    var fields = Context.getBuildFields();
    var newField = {
      name: "myFunc",
      doc: null,
      meta: [],
      access: [APublic],
      kind: FMethod(MethNormal),
      pos: Context.currentPos()
    };
    fields.push(newField);
    return fields;
  }
}