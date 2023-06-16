package spec.convert;

import AST.FuncObj;

class FunctionObservable {
	/**
	 * GENERIC
	 */
	static public function create(func:FuncObj, tabs:String = '\t'):String {
		return '/**
		${build(func, tabs)}
		*/';
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
	static private function build(func:FuncObj, tabs:String = '\t'):String {
		var out = '';
		out += '// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\t// url used (TODO: check if this value is correct)
${tabs}\t${ConvertURL(func)}
${tabs}\t// Act
${tabs}\t${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\tconst mockReq = httpTestingController.expectOne(_url);
${tabs}\texpect(mockReq.request.url).toBe(_url);
${tabs}\texpect(mockReq.request.method).toBe("${(func._guessing.requestType)}");
${tabs}\texpect(mockReq.cancelled).toBeFalsy();
${tabs}\texpect(mockReq.request.responseType).toEqual(\'json\');
${tabs}\tmockReq.flush(_param${Strings.toUpperCamel(func.params[0].name)});
${tabs}\t// ${haxe.Json.stringify(func)}
';

		return out;
	}

	static function ConvertURL(func:FuncObj):String {
		var url = func._guessing.URL;
		url = url.replace('this.', '').replace('url ', '_url ');
		return 'const ' + url;
	}
}
