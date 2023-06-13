package spec;

import AST.FuncObj;

class ParamsFromFunction {
	static public function create(func:FuncObj, tabs:Null<String>):String {
		var out = '';
		for (i in 0...func.params.length) {
			var _TypedObj = func.params[i];
			out += 'const _param${Strings.toUpperCamel(_TypedObj.name)}: ${_TypedObj.type} = ${Type2Value.convertType2Value(_TypedObj.type)};\n${tabs}\t';
		}
		return out;
	}
}
