package spec.convert;

import AST.FuncObj;

/**
 *
 */
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
	 * create param vars based upon FuncOjb.params
	 *
	 * @example
	 *
	 *
	 * @param func
	 * @param tabs
	 * @return String
	 */
	static private function build(func:FuncObj, tabs:String = '\t'):String {
		var out = '';
		for (i in 0...func.params.length) {
			var _typedObj = func.params[i];
			out += 'const _param${Strings.toUpperCamel(_typedObj.name)}: ${_typedObj.type} = ${Type2Value.convertType2Value(_typedObj.type)};';
			if (i < func.params.length - 1) {
				out += '\n${tabs}\t';
			}
		}
		return out;
	}
}
