package spec;

import AST.FuncObj;

class Call2Function {
	static public function create(func:FuncObj, tabs:Null<String>):String {
		var param = '';
		var out = '';
		for (i in 0...func.params.length) {
			var _TypedObj = func.params[i];
			param += '_param${Strings.toUpperCamel(_TypedObj.name)}';
			if (i < func.params.length - 1) {
				param += ', ';
			}
		}
		return 'component.${func.name}(${param})';
	}
}
