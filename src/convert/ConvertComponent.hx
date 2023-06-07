package convert;

import utils.TranslateName;
import utils.GenValues;
import utils.RegEx;
import AST;
import const.Config;
import haxe.Json;
import remove.RemoveComment;
import spec.SpecComponent;
import utils.Copyright;
import utils.GeneratedBy;

class ConvertComponent {
	private var OBJ:TypeScriptClassObject;

	/**
	 * constructor
	 * @param path to original file (at this moment probably a component)
	 */
	public function new(path:String) {
		// read the content of the file
		var originalContent = sys.io.File.getContent(path);
		var originalContentNoComment = RemoveComment.all(originalContent, 'ts');

		// filename
		var originalFileName = Path.withoutDirectory(path);
		var newFileName = originalFileName.replace('.ts', '.spec.ts');
		var className = originalFileName.replace('.component.ts', '');

		// parent dir
		var parent = Path.directory(path);

		// first try for new extract
		Extract.runExtract(originalContentNoComment, originalFileName.replace('.component.ts', ''), 'Component');
		OBJ = Extract.OBJ;

		// start creating the spec of this file/component
		var ts = new SpecComponent(className, OBJ);
		// // add imports
		// ts.addImport('// add imports');
		// // add constructor
		// ts.addConstructor('// add constructor');
		// // add providers
		// ts.addProviders('/* add providers */');
		// // add testbed
		// ts.addTestbed('// testbed');
		// // add values
		// ts.addVariable('// add vars');
		// // add functions
		// ts.addFunction('// add functions');

		// return;

		// -----------------------------------------------------------
		// update class vars
		// -----------------------------------------------------------
		// ts.addVariable('// vars');
		if (OBJ.vars.length >= 0) {
			var name = '${Strings.toUpperCamel(className)}Component';
			mute('use test for class vars "${name}"');
			ts.addFunction('// ${name}');
			ts.addFunction('describe(\'${name} class vars\', () => {');
			// // ts.addFunction('// OBJ.vars.length: ${OBJ.vars.length}\n');
			for (i in 0...OBJ.vars.length) {
				// ts.addFunction('// ${OBJ.vars[i]}');
				var _varObj:VarObj = OBJ.vars[i];
				// ts.addFunction('\t// ${_varObj.name}');
				ts.addFunction(createVarsTest(_varObj, '\t\t'));
			}
			ts.addFunction('});\n');
		}

		// -----------------------------------------------------------
		// update the imports
		// -----------------------------------------------------------
		ts.addImport('// import directly from ${className}.component');
		for (i in 0...OBJ.imports.length) {
			var _import = OBJ.imports[i];
			// There are some imports that are not needed, exclude them and show the rest
			// ignore
			if (_import.indexOf('HttpClient') != -1)
				continue;
			if (_import.indexOf('Observable') != -1)
				continue;
			if (_import.indexOf('Injectable') != -1)
				continue;
			// not ignored
			ts.addImport('${_import}');
		}

		// -----------------------------------------------------------
		// update constructor
		// -----------------------------------------------------------
		// log(OBJ.constructor);
		// ts.addConstructor('// constructor');
		for (i in 0...OBJ.constructor.params.length) {
			var _constructor = OBJ.constructor.params[i];
			// trace(_constructor);
			// if (_constructor.type.indexOf('HttpClient') != -1)
			// 	continue;
			// add to constructor
			ts.addConstructor('\tlet ${_constructor.name}: ${_constructor.type};');
			ts.addConstructor('\tlet ${_constructor.name}Spy: jasmine.SpyObj<${_constructor.type}>;');
			// add to testbed
			ts.addTestbed('\t\t${_constructor.name} = TestBed.inject(${_constructor.type});');
			ts.addTestbed('\t\t${_constructor.name}Spy = TestBed.inject(${_constructor.type}) as jasmine.SpyObj<${_constructor.type}>;');
			// add to providers
			ts.addProviders('${_constructor.type}');
		}

		// -----------------------------------------------------------
		// update the functions
		// -----------------------------------------------------------
		for (i in 0...OBJ.functions.length) {
			var _func:FuncObj = OBJ.functions[i];
			// trace(_func);
			ts.addFunction('// ${i + 1}. Generated test for "${_func.name}"');

			// log('${i}. - title test: ${getTitle(_func)}');

			var isGetter:Bool = (_func.name.indexOf('get') != -1) ? true : false;
			var isSetter:Bool = (_func.name.indexOf('set') != -1) ? true : false;
			var isObservable:Bool = (_func._content.indexOf('Observable') != -1) ? true : false;
			var isReturnArray:Bool = (_func.returnValue.type.indexOf('[]') != -1) ? true : false;
			var isReturnUnion:Bool = (_func.returnValue.type.indexOf('|') != -1) ? true : false;

			// warn('is this a getter: ' + isGetter);
			// warn('is this a setter: ' + isSetter);
			// warn('is this a isObservable: ' + isObservable);
			// warn('is this a isReturnArray: ' + isReturnArray);
			// warn('is this a isReturnUnion: ' + isReturnUnion);

			// log(_func);
			// log(Config.IS_BASIC);
			if (_func._content == 'ngOnInit(): void { }') {
				ts.addFunction(createEmptyOnInitTest(_func, '\t'));
				// continue;
			}

			if (Config.IS_BASIC) {
				// [hooks?] ngOnInit /
				// TODO ngOnDestroy
				if (_func.name == 'ngOnInit') {
					mute('use test with return value "${_func.returnValue.type}"');
					ts.addFunction('describe(\'ngOnInit\', () => {');
					ts.addFunction(createBasicTest(_func, '\t\t'));
					ts.addFunction('});\n');

					// ts.addFunction('// OBJ.vars.length: ${OBJ.vars.length}\n');
				} else {
					mute('use test with return value "${_func.returnValue.type}"');
					ts.addFunction(createBasicTest(_func));
				}
			} else {
				// not basic
				// [hooks?] ngOnInit
				// warn(_func._content);

				if (_func.name == 'ngOnInit') {
					mute('use ngOnInit test with return value "${_func.returnValue.type}"');
					ts.addFunction('describe(\'${_func.name}\', () => {');
					ts.addFunction(createOnInitTest(_func, '\t\t'));
					ts.addFunction('});\n');
				} else if (_func.name == 'ngOnChanges') {
					mute('use ngOnChanges test with return value "${_func.returnValue.type}"');
					ts.addFunction('describe(\'${_func.name}\', () => {');
					ts.addFunction(createOnChangeTest(_func, '\t\t'));
					ts.addFunction('});\n');
				} else {
					mute('use test with return value "${_func.returnValue.type}"');
					ts.addFunction('describe(\'${_func.name}\', () => {');
					ts.addFunction(createComboTest(_func, '\t\t'));
					ts.addFunction('});\n');
				}
			}
		}

		// -----------------------------------------------------------
		// create and save file
		// -----------------------------------------------------------

		// default typescript template
		var content:String = //
			GeneratedBy.message('ts') //
			+ '\n\n' //
			+ Copyright.init('ts') //
			+ '\n\n' //
			+ ts.create() //
			+ '';

		// + '/**\n\n${originalContentNoComment}\n\n*/';

		// correct filename
		var templatePath = '${parent}/${newFileName}';
		var jsonPath = '${parent}/_${newFileName.replace('.spec.ts', '.json')}';
		var json = Json.stringify(OBJ, null, '  ');

		if (!Config.IS_OVERWRITE) {
			// create a name that is destincable from orignal file
			templatePath = '${parent}/${newFileName.replace('.spec', '_gen_.spec')}';
		}

		if (Config.IS_DRYRUN) {
			info('DRYRUN: write ${templatePath.split('/src')[1]}', 2);
		} else {
			info('Open original file: ${path}', 2);
			info('Open generated test file: ${templatePath}', 2);
			info('Open generated json file: ${jsonPath}', 2);
			content = content.replace('\n\n\n', '\n\n');
			content = content.replace('\n\n', '\n');
			// // content = content.replace('\n\n\n', '\n');
			// // content = content.replace('\n\n\n', '\n\n').replace('\n\n', '\n');
			sys.io.File.saveContent(templatePath, content);
			sys.io.File.saveContent(jsonPath, json);
		}

		// warn('${Emoji.x} ${Type.getClassName(ConvertService)} ${path}');
		// log(json);
	}

	// ____________________________________ create test based upon return type ____________________________________

	function createOnChangeTest(func:FuncObj, ?tabs:String = '\t'):String {
		var out = '\n';
		// out += '${tabs}// Test with return type `${func.returnValue.type}`\n${tabs}';
		// out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
		// out += '${tabs}it(\'${getSubTitle(func)}\', () => {
		out += '${tabs}it(\'#should check if ngOnChanges exists\', () => {
${tabs}\tlet _changes: SimpleChanges = {};
${tabs}\tcomponent.ngOnChanges(_changes);
${tabs}\texpect(component.ngOnChanges).toBeDefined();
${tabs}});
${tabs}
${tabs}xit(\'#should check what ngOnChanges does\', () => {
${tabs}\t// let _spy = spyOn(component, \'init\');
${tabs}\tlet _changes: SimpleChanges = {};
${tabs}\tcomponent.ngOnChanges(_changes);
${tabs}\texpect(component.ngOnChanges).toBeDefined();
${tabs}\t// expect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}
';
		return out;
	}

	function createOnInitTest(func:FuncObj, ?tabs:String = '\t'):String {
		var out = '\n';
		// out += '${tabs}// Test with return type `${func.returnValue.type}`\n${tabs}';
		// out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
		// out += '${tabs}it(\'${getSubTitle(func)}\', () => {
		out += '${tabs}it(\'#should check if ngOnInit exists \', () => {
${tabs}\tcomponent.ngOnInit();
${tabs}\texpect(component.ngOnInit).toBeDefined();
${tabs}});
${tabs}
${tabs}xit(\'#should check what ngOnInit does\', () => {
${tabs}\t// let _spy = spyOn(component, \'init\');
${tabs}\tcomponent.ngOnInit();
${tabs}\texpect(component.ngOnInit).toBeDefined();
${tabs}\t// expect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}
';
		return out;
	}

	function createComboTest(func:FuncObj, ?tabs:String = '\t'):String {
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
${tabs}\t${(func.params.length > 0) ? 'const _param${Strings.toUpperCamel(func.params[0].name)}: ${func.params[0].type} = ${convertFuncParams2Value(func)};' : '// '}
${tabs}\tconst _return${Strings.toUpperCamel(func.returnValue.type)}: ${func.returnValue.type} = ${convertFuncReturn2Value(func)};
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
${tabs}\t${(func.params.length > 0) ? 'const _param${Strings.toUpperCamel(func.params[0].name)}: ${func.params[0].type} = ${convertFuncParams2Value(func)};' : '// '}
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
${tabs}\t${createParamsFromFunction(func, tabs)}
${tabs}\tconst _spy = spyOn(component, \'${func.name}\');
${tabs}\t// Act
${tabs}\t${createCall2Function(func, tabs)};
${tabs}\t// Assert
${tabs}\texpect(component.${func.name}).toBeDefined();
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}\n';

			default:
				out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
				out += 'xit(\'${getTitle(func)}\', () => {
${tabs}\t//
${tabs}});\n';
				trace("case '" + func.returnValue.type + "': trace ('" + func.returnValue.type + "');");
		}

		return out;
	}

	function createCall2Function(func:FuncObj, tabs:Null<String>):String {
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

	function createParamsFromFunction(func:FuncObj, tabs:Null<String>):String {
		var out = '';
		for (i in 0...func.params.length) {
			var _TypedObj = func.params[i];
			out += 'const _param${Strings.toUpperCamel(_TypedObj.name)}: ${_TypedObj.type} = ${convertType2Value(_TypedObj.type)};\n${tabs}\t';
		}
		return out;
	}

	function createBasicTest(func:FuncObj, ?tabs:String = '\t'):String {
		var out = '\n';
		out += '${tabs}// Basic test with return type `${func.returnValue.type}`\n${tabs}';
		// out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
		out += 'it(\'${getTitle(func)}\', () => {
${tabs}\t//
${tabs}});';
		return out;
	}

	function createEmptyOnInitTest(func:FuncObj, ?tabs:String = '\t'):String {
		var out = '';
		out += '${tabs}// this looks like an emtpy ngOnInit\n${tabs}';
		// out += '// Basic test with return type `${func.returnValue.type}`\n${tabs}';
		// out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
		out += '/**\n${tabs}';
		out += 'it(\'${getTitle(func)}\', () => {
${tabs}\t//
${tabs}});
${tabs}*/
';
		return out;
	}

	/**
	 * [Description]
	 * @param func
	 * @param vars
	 * @param tabs
	 * @return String
	 */
	function createVarsTest(vars:VarObj, ?tabs:String = '\t'):String {
		var title = ShouldTitleTest.getShouldVarsTitle(vars);

		// TODO: not sure how to do FormControl so remove it for now
		// not sure what to do with this value, so for now I will comment the test
		var isFormControl = vars._content.indexOf('FormControl') != -1;
		var isFormGroup = vars._content.indexOf('FormGroup') != -1;

		var out = '';

		// out += '// this looks like an emtpy ngOnInit\n${tabs}';
		// out += '// Basic test with return type `${func.returnValue.type}`\n${tabs}';
		// out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
		// out += '/**\n${tabs}';
		// log(func);

		out += '\n${tabs}';
		if (isFormControl || isFormGroup)
			out += '/**\n${tabs}';

		out += 'it(\'${title}\', () => {
${tabs}\t${convertVarsObj2Test(vars, tabs)}
${tabs}});
';

		if (isFormControl || isFormGroup)
			out += '\n${tabs}*/';
		// out += '${tabs}*/';
		return out;
	}

	// ____________________________________ use vars ____________________________________
	// create vars test based upon variables private/public in class
	function convertVarsObj2Test(vars:VarObj, ?tabs:String = '\t') {
		var out = '// Arrange
${tabs}\tconst _${vars.name}: ${vars.type} = ${convertVar2Value(vars)};
${tabs}\tconst _initial${Strings.toUpperCamel(vars.name)}: ${vars.type} ${(vars.optional) ? '| undefined' : ''}= component.${vars.name};
${tabs}\tcomponent.${vars.name} = _${vars.name};
${tabs}\t// Act
${tabs}\t${(OBJ.hasOnInit) ? 'component.ngOnInit();' : ''}
${tabs}\t// Assert
${tabs}\t${(vars.value == "") ? 'expect(_initial${Strings.toUpperCamel(vars.name)}).toBeUndefined();' : 'expect(_initial${Strings.toUpperCamel(vars.name)}).toBe(${vars.value});'}
${tabs}\texpect(component.${vars.name}).toBe(_${vars.name});';
		return out;
	}

	// ____________________________________ converters ____________________________________

	function convertFuncReturn2Value(func:FuncObj) {
		return convertType2Value(func.returnValue.type);
	}

	function convertFuncParams2Value(func:FuncObj) {
		return convertType2Value(func.params[0].type);
	}

	function convertVar2Value(vars:VarObj):String {
		var out = convertType2Value(vars.type);
		if (vars.value != "") {
			out = vars.value;
		}
		// TODO: not sure how to do FormControl so remove it for now
		if (vars._content.indexOf('FormControl') != -1) {
			out = '';
		}
		return out;
	}

	function convertType2Value(type:String):String {
		var out = '';
		switch (type) {
			case 'string':
				out = '"${GenValues.string()}"';
			case 'string[]':
				out = '["${GenValues.string()}", "${GenValues.string()}"]';
			case 'bool', 'boolean':
				out = 'true';
			case 'number', 'float':
				out = '5000';
			case 'date', 'Date', 'string | Date':
				out = 'new Date()';
			case 'any':
				out = '{}';
			case 'Function', 'function':
				out = '() => {}';
			case 'undefined':
				out = 'undefined';
			case 'null':
				out = 'null';
			default:
				// SPEC_CONST.getValue(IHELP)
				out = '{} /* SPEC_CONST.getValue(${type.toUpperCase()}) */';
				trace("case '" + type + "': trace ('" + type + "');");
		}
		return out;
	}

	// ____________________________________ misc/tools ____________________________________

	/**
	 * convert params to string to use in call function
	 * ```ts
	 * service.func(param);
	 * ```
	 *
	 * @param func
	 * @return String
	 */
	function convertFuncObjParam2String(func:FuncObj):String {
		var _param = '';
		for (i in 0...func.params.length) {
			var _p = func.params[i];
			_param += '${_p.name}';
			if ((i + 1) < func.params.length) {
				_param += ', ';
			}
		}
		return _param;
	}

	/**
	 * create a readable description of the test (?)
	 *
	 * @param obj
	 */
	function getTitle(obj:FuncObj) {
		return ShouldTitleTest.getTitle(obj);
	}

	function getSubTitle(func:FuncObj) {
		return ShouldTitleTest.getSubTitle(func);
	}
}
