package spec.convert;

import AST.VarObj;

class VarsObj2Test {
	// create vars test based upon variables private/public in class

	/**
	 * GENERIC
	 */
	static public function create(vars:VarObj, ?tabs:String = '\t') {
		var out = '// Arrange
${tabs}\t//
${tabs}\t// Act
${tabs}\t//
${tabs}\t// Assert
${tabs}\t//
';
		return out;
	}

	/**
	 * COMPONENTS
	 */
	static public function components(vars:VarObj, ?tabs:String = '\t') {
		var out = '// Arrange
${tabs}\tconst _${vars.name}: ${vars.type} = ${Var2Value.create(vars)};
${tabs}\tconst _initial${Strings.toUpperCamel(vars.name)}: ${vars.type} ${(vars.optional) ? '| undefined' : ''}= component.${vars.name};
${tabs}\tcomponent.${vars.name} = _${vars.name};
${tabs}\t// Act
${tabs}\t${(Constants.HAS_ONINIT) ? 'component.ngOnInit();' : ''}
${tabs}\t// Assert
${tabs}\t${(vars.value == "") ? 'expect(_initial${Strings.toUpperCamel(vars.name)}).toBeUndefined();' : 'expect(_initial${Strings.toUpperCamel(vars.name)}).toBe(${vars.value});'}
${tabs}\texpect(component.${vars.name}).toBe(_${vars.name});';
		return out;
	}

	/**
	 * SERVICES
	 */
	static public function services(vars:VarObj, ?tabs:String = '\t') {
		var out = '// Arrange
${tabs}\tconst _${vars.name}: ${vars.type} = ${Var2Value.create(vars)};
${tabs}\tconst _initial${Strings.toUpperCamel(vars.name)}: ${vars.type} ${(vars.optional) ? '| undefined' : ''}= service.${vars.name};
${tabs}\t// Act
${tabs}\tservice.${vars.name} = _${vars.name};
${tabs}\t// Assert
${tabs}\t${(vars.value == "") ? 'expect(_initial${Strings.toUpperCamel(vars.name)}).toBeUndefined();' : 'expect(_initial${Strings.toUpperCamel(vars.name)}).toBe(${vars.value});'}
${tabs}\texpect(service.${vars.name}).toBe(_${vars.name});';
		return out;
	}
}
