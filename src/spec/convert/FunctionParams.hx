package spec.convert;

import AST.FuncObj;

class FunctionParams {
	/**
	 * GENERIC
	 */
	static public function create(func:FuncObj, tabs:String = '\t'):String {
		return '// ${build(func, tabs)}';
	}

	/**
	 * COMPONENTS
	 */
	static public function components(func:FuncObj, tabs:String = '\t'):String {
		return '${build(func, tabs)}';
	}

	/**
	 * SEVICES
	 */
	static public function services(func:FuncObj, tabs:String = '\t'):String {
		return '${build(func, tabs)}';
	}

	/**
	 * [Description]
	 * @param func
	 * @param tabs
	 * @return String
	 */
	static private function build(func:FuncObj, tabs:Null<String>):String {
		var out = '';
		for (i in 0...func.params.length) {
			var _TypedObj = func.params[i];
			out += 'const _param${Strings.toUpperCamel(_TypedObj.name)}: ${_TypedObj.type} = ${Type2Value.convertType2Value(_TypedObj.type)};\n${tabs}\t';
		}
		return out;
	}
}
