package spec.convert;

import AST.FuncObj;

/**
 * create a call to this specific function
 *
 * @see FuncObj
 * @example
 * ```ts
 * // Act
 * service.foo(bar,soap);
 * ```
 */
class FunctionCall {
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
		return 'component.${build(func, tabs)};';
	}

	/**
	 * SEVICES
	 */
	static public function services(func:FuncObj, tabs:String = '\t'):String {
		return 'service.${build(func, tabs)};';
	}

	/**
	 *
	 *
	 * @param func
	 * @param tabs
	 * @return String
	 */
	private static function build(func:FuncObj, tabs:String = '\t'):String {
		var param = '';
		var out = '';
		for (i in 0...func.params.length) {
			var _typedObj = func.params[i];
			param += '_param${Strings.toUpperCamel(_typedObj.name)}';
			if (i < func.params.length - 1) {
				param += ', ';
			}
		}
		return '${func.name}(${param})';
	}
}
