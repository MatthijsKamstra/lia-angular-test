package spec;

import AST.VarObj;

class VarsObj2Test {
	// create vars test based upon variables private/public in class

	/**
	 * [Description]
	 * @param vars
	 * @param tabs
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
	 * [Description]
	 * @param vars
	 * @param tabs
	 */
	static public function components(vars:VarObj, ?tabs:String = '\t') {
		var out = '// Arrange
${tabs}\tconst _${vars.name}: ${vars.type} = ${spec.Var2Value.create(vars)};
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
	 * for services
	 * @param vars
	 * @param tabs
	 */
	static public function services(vars:VarObj, ?tabs:String = '\t') {
		var out = '// Arrange
${tabs}\tconst _${vars.name}: ${vars.type} = ${spec.Var2Value.create(vars)};
${tabs}\t// Act
${tabs}\tcomponent.${vars.name} = _${vars.name};
${tabs}\t// Assert
${tabs}\t${(vars.value == "") ? 'expect(_initial${Strings.toUpperCamel(vars.name)}).toBeUndefined();' : 'expect(_initial${Strings.toUpperCamel(vars.name)}).toBe(${vars.value});'}
${tabs}\texpect(component.${vars.name}).toBe(_${vars.name});';
		return out;
	}
}
