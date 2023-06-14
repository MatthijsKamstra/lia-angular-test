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
	static public function create():String {
		return '// TODO';
	}

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

		switch (func.returnValue.type) {
			case 'string':
				trace('string');
				out += 'it(\'#should return string\', () => {
${tabs}\t// Arrange
${tabs}\t// TODO
${tabs}});
${tabs}\n';
			case 'boolean':
				// ${tabs}\t// ${func.params}
				// trace('boolean');
				// out += 'it(\'${getSubTitle(func)}\', () => {
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
${tabs}\t${FunctionParams.create(func, tabs)}
${tabs}\tconst _spy = spyOn(component, \'${func.name}\');
${tabs}\t// Act
${tabs}\t${FunctionCall.create(func, tabs)};
${tabs}\t// Assert
${tabs}\texpect(component.${func.name}).toBeDefined();
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
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

	/**
	 * SERVICES
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
			case 'string':
				trace('string');
				out += 'it(\'#should return string\', () => {
${tabs}\t// Arrange
${tabs}\t// TODO
${tabs}});
${tabs}\n';
			case 'boolean':
				// ${tabs}\t// ${func.params}
				// trace('boolean');
				// out += 'it(\'${getSubTitle(func)}\', () => {
				out += 'it(\'#should return boolean true\', () => {
${tabs}\t// Arrange
${tabs}\t${(func.params.length > 0) ? 'const _param${Strings.toUpperCamel(func.params[0].name)}: ${func.params[0].type} = ${Type2Value.convertFuncParams2Value(func)};' : '// '}
${tabs}\tconst _return${Strings.toUpperCamel(func.returnValue.type)}: ${func.returnValue.type} = ${Type2Value.convertFuncReturn2Value(func)};
${tabs}\tconst _spy = spyOn(service, \'${func.name}\').and.returnValue(_return${Strings.toUpperCamel(func.returnValue.type)});
${tabs}\t// Act
${tabs}\t${(func.params.length > 0) ? 'service.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)}' : 'service.${func.name}()'};
${tabs}\t// Assert
${tabs}\texpect(service.${func.name}).toBeDefined();
${tabs}\t${(func.params.length > 0) ? 'expect(service.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)})).toBeTrue()' : 'expect(service.${func.name}()).toBeTrue()'};
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}
${tabs}it(\'#should return boolean false\', () => {
${tabs}\t// Arrange
${tabs}\t${(func.params.length > 0) ? 'const _param${Strings.toUpperCamel(func.params[0].name)}: ${func.params[0].type} = ${Type2Value.convertFuncParams2Value(func)};' : '// '}
${tabs}\tconst _return${Strings.toUpperCamel(func.returnValue.type)}: ${func.returnValue.type} = false;
${tabs}\tconst _spy = spyOn(service, \'${func.name}\').and.returnValue(_return${Strings.toUpperCamel(func.returnValue.type)});
${tabs}\t// Act
${tabs}\t${(func.params.length > 0) ? 'service.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)})' : 'service.${func.name}()'};
${tabs}\t// Assert
${tabs}\texpect(service.${func.name}).toBeDefined();
${tabs}\t${(func.params.length > 0) ? 'expect(service.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)})).toBeFalse()' : 'expect(service.${func.name}()).toBeFalse()'};
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}\n';
			case 'void':
				// trace('void');
				out += 'it(\'#should spy on "${func.name}" with return void\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.create(func, tabs)}
${tabs}\tconst _spy = spyOn(service, \'${func.name}\');
${tabs}\t// Act
${tabs}\t${FunctionCall.services(func, tabs)};
${tabs}\t// Assert
${tabs}\texpect(service.${func.name}).toBeDefined();
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
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
}