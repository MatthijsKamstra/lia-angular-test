package spec.convert;

import AST.FuncObj;
import convert.ShouldTitleTest;

/**
 * use the retrun type of a function to generate a test
 * @see FuncObj
 *
 * @example
 * 		`function foo() : boolean { }`
 */
class ComboTest {
	// -----------------------------------------------------------
	// GENERIC
	// -----------------------------------------------------------

	/**
	 * [Description]
	 * @return String
	 */
	static public function create():String {
		return '// TODO';
	}

	// -----------------------------------------------------------
	// COMPONENTS
	// -----------------------------------------------------------

	/**
	 * specific for Components, use the retrun type of a function to generate a test
	 *
	 * @param func
	 * @param tabs
	 * @return String
	 */
	static public function components(func:FuncObj, ?tabs:String = '\t'):String {
		// warn('test');

		var out = '\n';
		out += '${tabs}// test with return type `${func.returnValue.type}`\n${tabs}';

		if (func.name == 'ngOnInit') {
			out += '// specific test for ngOnInit\n${tabs}';
			out += 'it(\'#should check if ngOnInit exists \', () => {
${tabs}\t// Arrange
${tabs}\t// Act
${tabs}\tcomponent.ngOnInit();
${tabs}\t// Assert
${tabs}\texpect(component.ngOnInit).toBeDefined();
${tabs}});
${tabs}
${tabs}/*
${tabs}it(\'#should check what ngOnInit does\', () => {
${tabs}\t// let _spy = spyOn(component, \'init\');
${tabs}\tcomponent.ngOnInit();
${tabs}\texpect(component.ngOnInit).toBeDefined();
${tabs}\t// expect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}*/;
${tabs}\n${tabs}';
		}

		if (func.name == 'ngOnChanges') {
			out += '// specific test for ngOnChanges\n${tabs}';
			out += 'it(\'#should check if ngOnChanges exists \', () => {
${tabs}\t// Arrange
${tabs}\tlet _changes: SimpleChanges = {};
${tabs}\t// Act
${tabs}\tcomponent.ngOnChanges(_changes);
${tabs}\t// Assert
${tabs}\texpect(component.ngOnChanges).toBeDefined();
${tabs}});
${tabs}
${tabs}/*
${tabs}it(\'#should check what ngOnChanges does\', () => {
${tabs}\t// let _spy = spyOn(component, \'init\');
${tabs}\tlet _changes: SimpleChanges = {};
${tabs}\tcomponent.ngOnChanges(_changes);
${tabs}\texpect(component.ngOnChanges).toBeDefined();
${tabs}\t// expect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}*/;
${tabs}\n${tabs}';
		}

		switch (func.returnValue.type) {
			// 			case 'string':
			// 				trace('string');
			// 				out += 'it(\'#should return string\', () => {
			// ${tabs}\t// Arrange
			// ${tabs}\t// TODO
			// ${tabs}});
			// ${tabs}\n';
			case 'boolean':
				// ${tabs}\t// ${func.params}
				// trace('boolean');
				// out += 'it(\'${getSubTitle(func)}\', () => {
				out += '// TEST';
				out += 'it(\'#should return boolean true\', () => {
${tabs}\t// Arrange
${tabs}\t${(func.params.length > 0) ? 'const _param${Strings.toUpperCamel(func.params[0].name)}: ${func.params[0].type} = ${Type2Value.convertFuncParams2Value(func)};' : '// '}
${tabs}\tconst _return${Strings.toUpperCamel(func.returnValue.type)}: ${func.returnValue.type} = ${Type2Value.convertFuncReturn2Value(func)};
${tabs}\tconst _spy = spyOn(component, \'${func.name}\').and.returnValue(_return${Strings.toUpperCamel(func.returnValue.type)});
${tabs}\t// Act
${tabs}\t${(func.params.length > 0) ? 'component.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)}' : 'component.${func.name}()'};
${tabs}\t// Assert
${tabs}\texpect(component.${func.name}).toBeDefined();
${tabs}\t${(func.params.length > 0) ? 'expect(component.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)})).toBeTrue()' : 'expect(component.${func.name}()).toBeTrue()'};
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}
${tabs}it(\'#should return boolean false\', () => {
${tabs}\t// Arrange
${tabs}\t${(func.params.length > 0) ? 'const _param${Strings.toUpperCamel(func.params[0].name)}: ${func.params[0].type} = ${Type2Value.convertFuncParams2Value(func)};' : '// '}
${tabs}\tconst _return${Strings.toUpperCamel(func.returnValue.type)}: ${func.returnValue.type} = false;
${tabs}\tconst _spy = spyOn(component, \'${func.name}\').and.returnValue(_return${Strings.toUpperCamel(func.returnValue.type)});
${tabs}\t// Act
${tabs}\t${(func.params.length > 0) ? 'component.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)})' : 'component.${func.name}()'};
${tabs}\t// Assert
${tabs}\texpect(component.${func.name}).toBeDefined();
${tabs}\t${(func.params.length > 0) ? 'expect(component.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)})).toBeFalse()' : 'expect(component.${func.name}()).toBeFalse()'};
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}\n';
			case 'void':
				// trace('void');
				out += 'it(\'#should spy on "${func.name}" with return void\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.components(func, tabs)}
${tabs}\tconst _spy = spyOn(component, \'${func.name}\');
${tabs}\t// Act
${tabs}\t${FunctionCall.components(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(component.${func.name}).toBeDefined();
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}
${tabs}/*
${tabs}// dummy test to write a quick test
${tabs}it(\'${ShouldTitleTest.getTitle(func)}\', () => {
${tabs}\t// Arrange
${tabs}\tconst _IValue: IValue = SPEC_CONST.getValue(IValue);
${tabs}\t${FunctionParams.components(func, tabs)}
${tabs}\t// Act
${tabs}\tconst _${func.returnValue.type}: ${func.returnValue.type} = ${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(_${func.returnValue.type}).toEqual(_IValue.foo);
${tabs}});
${tabs}*/;
${tabs}\n';

			default:
				out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
				out += 'xit(\'${ShouldTitleTest.getTitle(func)}\', () => {
${tabs}\t//
${tabs}});\n';
				trace("case '" + func.returnValue.type + "': trace ('" + func.returnValue.type + "');");
		}

		return out;
	}

	// -----------------------------------------------------------
	// SERVICES
	// -----------------------------------------------------------

	/**
	 * specific for Services, use the retrun type of a function to generate a test
	 *
	 * @param func
	 * @param tabs
	 * @return String
	 */
	static public function services(func:FuncObj, ?tabs:String = '\t'):String {
		// warn('test');

		var out = '\n';
		out += '${tabs}// test with return type `${func.returnValue.type}`\n${tabs}';

		switch (func.returnValue.type) {
			// 			case 'string':
			// 				// trace('string');
			// 				out += 'it(\'#should return string\', () => {
			// ${tabs}\t// FIXME this is WIP
			// ${tabs}\t// Arrange
			// ${tabs}\t// Act
			// ${tabs}\t// Assert
			// ${tabs}});
			// ${tabs}\n';
			case 'boolean':
				// ${tabs}\t// ${func.params}
				// trace('boolean');
				// out += 'it(\'${getSubTitle(func)}\', () => {
				out += 'it(\'#should return boolean true\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\t${(func.params.length > 0) ? 'const _param${Strings.toUpperCamel(func.params[0].name)}: ${func.params[0].type} = ${Type2Value.convertFuncParams2Value(func)};' : '// '}
${tabs}\tconst _return${Strings.toUpperCamel(func.returnValue.type)}: ${func.returnValue.type} = ${Type2Value.convertFuncReturn2Value(func)};
${tabs}\tconst _spy = spyOn(service, \'${func.name}\').and.returnValue(_return${Strings.toUpperCamel(func.returnValue.type)});
${tabs}\t// Act
${tabs}\t${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(service.${func.name}).toBeDefined();
${tabs}\t${(func.params.length > 0) ? 'expect(service.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)})).toBeTrue()' : 'expect(service.${func.name}()).toBeTrue()'};
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}
${tabs}it(\'#should return boolean false\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\t${(func.params.length > 0) ? 'const _param${Strings.toUpperCamel(func.params[0].name)}: ${func.params[0].type} = ${Type2Value.convertFuncParams2Value(func)};' : '// '}
${tabs}\tconst _return${Strings.toUpperCamel(func.returnValue.type)}: ${func.returnValue.type} = false;
${tabs}\tconst _spy = spyOn(service, \'${func.name}\').and.returnValue(_return${Strings.toUpperCamel(func.returnValue.type)});
${tabs}\t// Act
${tabs}\t${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(service.${func.name}).toBeDefined();
${tabs}\t${(func.params.length > 0) ? 'expect(service.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)})).toBeFalse()' : 'expect(service.${func.name}()).toBeFalse()'};
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}
${tabs}it(\'#should check return value "${func.name}"\', () => {
${tabs}\t// Arrange
${tabs}\t// Act
${tabs}\t// Assert
${tabs}\texpect(${FunctionCall.services(func, tabs).replace(';', '')}).toBeTrue();
${tabs}});
${tabs}\n';
			case 'void':
				// trace('void');
				out += 'it(\'#should spy on "${func.name}" with return void\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\tconst _spy = spyOn(service, \'${func.name}\');
${tabs}\t// Act
${tabs}\t${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(service.${func.name}).toBeDefined();
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}
${tabs}/*
${tabs}// dummy test to write a quick test
${tabs}it(\'${ShouldTitleTest.getTitle(func)}\', () => {
${tabs}\t// Arrange
${tabs}\tconst _IValue: IValue = SPEC_CONST.getValue(IValue);
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\t// Act
${tabs}\tconst _${func.returnValue.type}: ${func.returnValue.type} = ${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(_${func.returnValue.type}).toEqual(_IValue.foo);
${tabs}});
${tabs}*/;
${tabs}\n';
			case 'Observable':
				// trace('Observable');
				out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
				out += '${TestObservable.services(func, tabs)}';
			// out += 'it(\'#should return Observable<${func.returnValue.value}>\', () => {
			// ${tabs}\t// FIXME "${func.name}" with return type "${func.returnValue.type}"
			// ${tabs}\t${FunctionObservable.services(func, tabs)}
			// ${tabs}});
			// ${tabs}\n';
			default:
				// out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
				out += 'it(\'${ShouldTitleTest.getTitle(func)}\', () => {
${tabs}\t// FIXME "${func.name}" with return type `${func.returnValue.type}` (x)
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\tconst _return${Strings.toUpperCamel(func.returnValue.type)}: ${func.returnValue.type} = ${Type2Value.convertFuncReturn2Value(func)};
${tabs}\tconst _spy = spyOn(service, \'${func.name}\').and.returnValue(_return${Strings.toUpperCamel(func.returnValue.type)});
${tabs}\t// Act
${tabs}\t${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(service.${func.name}).toBeDefined();
${tabs}\t${(func.params.length > 0) ? 'expect(service.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)}).toBe(_return${Strings.toUpperCamel(func.returnValue.type)})' : 'expect(service.${func.name}()).toBe(_return${Strings.toUpperCamel(func.returnValue.type)})'};
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}
${tabs}/*
${tabs}// dummy test to write a quick test
${tabs}it(\'${ShouldTitleTest.getTitle(func)}\', () => {
${tabs}\t// Arrange
${tabs}\tconst _IValue: IValue = SPEC_CONST.getValue(IValue);
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\t// Act
${tabs}\tconst _${func.returnValue.type}: ${func.returnValue.type} = ${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(_${func.returnValue.type}).toEqual(_IValue.foo);
${tabs}});
${tabs}*/
${tabs}';

				trace("case '" + func.returnValue.type + "': trace ('" + func.returnValue.type + "');");
		}

		// ${tabs}\t${(func.params.length > 0)
		// ?
		// 'expect(service.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)}).toBe(_param${Strings.toUpperCamel(func.params[0].name)}})'
		// :
		// 'expect(service.${func.name}()).toBe(_param${Strings.toUpperCamel(func.params[0].name)})';
		return out;
	}
}
