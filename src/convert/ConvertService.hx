package convert;

import AST;
import const.Config;
import haxe.Json;
import remove.RemoveComment;
import remove.RemoveStuff;
import utils.Copyright;
import utils.GeneratedBy;

class ConvertService {
	// private var OBJ:TypeScriptClassObject;
	@:isVar public var OBJ(get, set):TypeScriptClassObject;

	/**
	 * constructor
	 * @param path to original file (at this moment probably a service)
	 */
	public function new(path:String) {
		// read the content of the file
		var originalContent = sys.io.File.getContent(path);
		var _originalContentNoComment = RemoveComment.all(originalContent, 'ts');
		var originalContentCleaned = RemoveStuff.all(originalContent, 'ts');

		// filename
		var originalFileName = Path.withoutDirectory(path);
		var newFileName = originalFileName.replace('.ts', '.spec.ts');
		var className = originalFileName.replace('.service.ts', '');

		// parent dir
		var parent = Path.directory(path);

		// first try for new extract
		Extract.runExtract(originalContentCleaned, originalFileName.replace('.service.ts', ''));
		OBJ = Extract.OBJ;

		// start creating the spec of this file/service
		var ts = new SpecService(className, OBJ);
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

		// -----------------------------------------------------------
		// update class vars
		// -----------------------------------------------------------
		// ts.addVariable('// vars');
		if (OBJ.vars.length >= 0) {
			var name = '${Strings.toUpperCamel(className)}Service';
			mute('use test for class vars "${name}"');
			ts.addFunction('// ${name}');
			ts.addFunction('describe(\'${name} class vars\', () => {');
			// // ts.addFunction('// OBJ.vars.length: ${OBJ.vars.length}\n');
			for (i in 0...OBJ.vars.length) {
				// ts.addFunction('// ${OBJ.vars[i]}');
				var _varObj:VarObj = OBJ.vars[i];
				// ts.addFunction('\t// ${_varObj.name}');
				ts.addFunction(VarsTest.services(_varObj, '\t\t'));
			}
			ts.addFunction('});\n');
		}

		// -----------------------------------------------------------
		// update subscibes
		// -----------------------------------------------------------
		if (OBJ.subscribes.length > 0) {
			ts.addSubscribes('// subscribes');
			ts.addImport('import { HttpEventType, HttpHeaders } from \'@angular/common/http\';');
			ts.addImport('import { SPEC_CONST } from \'src/app/shared/test/spec-helpers/constants.spec-helper\';');

			var name = '${Strings.toUpperCamel(className)}Service';
			mute('use subscribes in class "${name}"');
			for (i in 0...OBJ.subscribes.length) {
				var _sub:SubScribeObj = OBJ.subscribes[i];
				ts.addSubscribes('\t// ${name} subscribe of ${_sub.name}');
				ts.addSubscribes('\tdescribe(\'${name} subscribes\', () => {');
				ts.addSubscribes(TestSubscribe.services(_sub, '\t\t'));
				ts.addSubscribes('\t});\n');
			}
		}

		// -----------------------------------------------------------
		// update the imports
		// -----------------------------------------------------------
		ts.addImport('// import directly from ${className}Service');
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
		/*
			for (i in 0...OBJ.constructor.params.length) {
				var _constructor = OBJ.constructor.params[i];
				// trace(_constructor);
				if (_constructor.type.indexOf('HttpClient') != -1)
					continue;
				ts.addConstructor('\tlet ${_constructor.name}: ${_constructor.type};');
				ts.addTestbed('\t\t${_constructor.name} = TestBed.inject(${_constructor.type});');
				ts.addProviders('${_constructor.type}');
			}
		 */
		for (i in 0...OBJ.constructor.params.length) {
			var _constructor = OBJ.constructor.params[i];
			// trace(_constructor);
			if (_constructor.type.indexOf('HttpClient') != -1)
				continue;
			// add to constructor
			ts.addConstructor('\tlet ${_constructor.name}: ${_constructor.type};');
			ts.addConstructor('\tlet ${_constructor.name}Spy: jasmine.SpyObj<${_constructor.type}>;');
			// add to testbed
			ts.addTestbed('\t\t${_constructor.name} = TestBed.inject(${_constructor.type});');
			ts.addTestbed('\t\t${_constructor.name}Spy = TestBed.inject(${_constructor.type}) as jasmine.SpyObj<${_constructor.type}>;');
			ts.addTestbed('\t\t// ${_constructor.name}Spy.[functionname].and.returnValue("foobar");');
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

			if (Config.IS_BASIC) {
				// [hooks?] ngOnInit /
				// TODO ngOnDestroy
			} else {
				mute('use test with return value "${_func.returnValue.type}"');
				ts.addFunction('describe(\'${_func.name}\', () => {');
				ts.addFunction(ComboTest.services(_func, '\t\t'));
				ts.addFunction('});\n');
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
		var jsonPath = '${parent}/${newFileName.replace('.spec.ts', '_gen_.json')}';
		var bacPath = '${parent}/${newFileName.replace('.spec.ts', '_gen_.ts.bac')}';
		var json = Json.stringify(OBJ, null, '  ');

		// var templatePath = '${parent}/${newFileName}';
		if (!Config.IS_OVERWRITE) {
			// create a name that is destincable from orignal file
			templatePath = '${parent}/${newFileName.replace('.spec', '_gen_.speec')}';
		}

		if (Config.IS_DRYRUN) {
			info('DRYRUN: write ${templatePath.split('/src')[1]}', 2);
		} else {
			info('Open original file: ${path}', 2);
			info('Open generated test file: ${templatePath}', 2);
			sys.io.File.saveContent(templatePath, content);
			info('Open generated json file: ${jsonPath}', 2);
			sys.io.File.saveContent(jsonPath, json);
			info('Open original file (cleaned): ${bacPath}', 2);
			sys.io.File.saveContent(bacPath, originalContentCleaned);
		}

		// warn('${Emoji.x} ${Type.getClassName(ConvertService)} ${path}');
	}

	// ____________________________________ create test based upon return type ____________________________________
	// 	/**
	// 	 * disabled test, without guessing
	// 	 *
	// 	 * @param func
	// 	 * @return String
	// 	 */
	// 	function createTestDisabled(func:FuncObj):String {
	// 		var out = '';
	// 		out += '// Test with return type `${func.returnValue.type}`\n\t';
	// 		out += '// [WIP] test is default disabled (`xit`) \n\t';
	// 		out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
	// 		out += 'xit(\'${getTitle(func)}\', () => {
	// 		// expect(result).toBe(true);
	// 		expect(service.${func.name}).toBeDefined();
	// 	});
	// ';
	// 		return out;
	// 	}
	// 	function createTestObservable(func:FuncObj):String {
	// 		var out = '';
	// 		out += '// Test with return type `Observable`\n\t';
	// 		// 	out += 'it(\'${getTitle(func)}\', () => {
	// 		// 	expect(true).toBe(true);
	// 		// });';
	// 		var varNameReturnValue = func.returnValue.value;
	// 		var varName = func.returnValue.value.toLowerCase().replace('[]', ' ');
	// 		// var varValue = getVarValueFromReturnValue(func.returnValue);
	// 		// TODO: maybe the return value of a function needs to better defined
	// 		// for now an quick and dirty fix
	// 		var __temp:Array<TypedObj> = [
	// 			{
	// 				name: '${func.returnValue.value.toLowerCase()}',
	// 				value: '',
	// 				type: '${func.returnValue.value}',
	// 				_content: ''
	// 			}
	// 		];
	// 		var funcValue = getFuncFrom(func, varName);
	// 		var funcURL = '// URL used in class\n\t\t';
	// 		// var funcURL = ' const${OBJ.URL != "" ? OBJ.URL : ""} // url used in class';
	// 		if (func._guessing != null && func._guessing.URL != '') {
	// 			funcURL += 'const ${func._guessing.URL != "" ? func._guessing.URL : ""}';
	// 		}
	// 		out += 'it(\'${getTitle(func)}\', (done: DoneFn) => {
	// 		// Arrange
	// 		${createVarFromFunctionParam(func.params)}
	// 		${createVarFromFunctionParam(__temp)}
	// 		${funcURL}
	// 		// Act
	// 		${funcValue}
	// 		// Assert
	// 		const mockReq = httpTestingController.expectOne(url);
	// 		expect(mockReq.request.url).toBe(url);
	// 		expect(mockReq.request.method).toBe("${(func._guessing.requestType)}");
	// 		expect(mockReq.cancelled).toBeFalsy();
	// 		expect(mockReq.request.responseType).toEqual(\'json\');
	// 		mockReq.flush(${varName});
	// 	});
	// ';
	// 		return out;
	// 	}
	// 	function createTestvoid(func:FuncObj):String {
	// 		var _param = convertFuncObjParam2String(func);
	// 		var out = '';
	// 		if (Config.IS_DEBUG) {
	// 			out += '// Test with return type `${func.returnValue.type}`\n\t';
	// 			out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
	// 		}
	// 		out += 'it(\'${getTitle(func)}\', () => {
	// 		// Arrange
	// 		${createVarFromFunctionParam(func.params)}
	// 		const result = service.${func.name}(${_param});
	// 		const spy = spyOn(service, \'${func.name}\');
	// 		// Act
	// 		service.${func.name}(${_param});
	// 		// Assert
	// 		expect(result).toBeUndefined();
	// 		expect(result).toBeFalsy();
	// 		expect(spy).toHaveBeenCalled();
	// 		expect(service.${func.name}).toBeDefined();
	// 	});
	// ';
	// 		return out;
	// 	}
	// 	function createTestArray(func:FuncObj) {
	// 		var _param = convertFuncObjParam2String(func);
	// 		// get return .... test!
	// 		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
	// 		var _return = '';
	// 		if (matches[0] != null) {
	// 			_return = matches[0] //
	// 				.replace('return', '') //
	// 				.replace(';', '') //
	// 				.replace('this', 'service') //
	// 				.trim();
	// 		}
	// 		// check for what array is used
	// 		var _arrayReturnType = '';
	// 		_arrayReturnType = func.returnValue.type.replace('[]', '');
	// 		var isCustomType = true;
	// 		switch (_arrayReturnType) {
	// 			case 'string', 'boolean', 'number':
	// 				isCustomType = false;
	// 			default:
	// 				trace("case '" + _arrayReturnType + "': trace ('" + _arrayReturnType + "');");
	// 		}
	// 		if (isCustomType) {
	// 			_return = '[]; // ${_return} // TODO add vars';
	// 		}
	// 		var out = '';
	// 		if (Config.IS_DEBUG) {
	// 			out += '// Test with return type `${func.returnValue.type}`\n\t';
	// 			out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
	// 		}
	// 		out += 'it(\'${getTitle(func)}\', () => {
	// 		// Arrange
	// 		${createVarFromFunctionParam(func.params)}
	// 		const arr: ${_arrayReturnType}[] = ${_return};
	// 		const spy = spyOn(service, \'${func.name}\').and.returnValue(arr);
	// 		const result: ${func.returnValue.type} = service.${func.name}(${_param});
	// 		// Act
	// 		service.${func.name}(${_param});
	// 		// Assert
	// 		expect(result).toEqual(arr);
	// 		expect(service.${func.name}).toBeDefined();
	// 		expect(spy).toHaveBeenCalled();
	// 	});
	// ';
	// 		return out;
	// 	}
	// 	function createTestString(func:FuncObj):String {
	// 		var _param = convertFuncObjParam2String(func);
	// 		// get return .... test!
	// 		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
	// 		var _return = '';
	// 		if (matches[0] != null) {
	// 			_return = matches[0] //
	// 				.replace('return', '') //
	// 				.replace(';', '') //
	// 				.replace('this', 'service') //
	// 				.trim();
	// 		}
	// 		var out = '';
	// 		if (Config.IS_DEBUG) {
	// 			out += '// Test with return type `${func.returnValue.type}`\n\t';
	// 			out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
	// 		}
	// 		out += 'it(\'${getTitle(func)}\', () => {
	// 		// Arrange
	// 		${createVarFromFunctionParam(func.params)}
	// 		const _${func.returnValue.type}: ${func.returnValue.type} = (${_return}); // "${GenValues.string()}";
	// 		const result: ${func.returnValue.type} = service.${func.name}(${_param});
	// 		const spy = spyOn(service, \'${func.name}\').and.returnValue(_${func.returnValue.type});
	// 		// Act
	// 		service.${func.name}(${_param});
	// 		// Assert
	// 		expect(result).toBe(_${func.returnValue.type});
	// 		expect(spy).toHaveBeenCalled();
	// 		expect(service.${func.name}(${_param})).toBe(_${func.returnValue.type});
	// 		expect(spy).toHaveBeenCalledTimes(2);
	// 		expect(service.${func.name}(${_param})).toContain(_${func.returnValue.type});
	// 		expect(spy).toHaveBeenCalledTimes(3);
	// 		expect(service.${func.name}(${_param})).toBe(_${func.returnValue.type});
	// 		expect(spy).toHaveBeenCalledTimes(4);
	// 		expect(service.${func.name}).toBeDefined();
	// 	});
	// ';
	// 		return out;
	// 	}
	// 	function createTestboolean(func:FuncObj):String {
	// 		var _param = convertFuncObjParam2String(func);
	// 		// get return .... test!
	// 		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
	// 		var _return = 'true';
	// 		if (matches[0] != null) {
	// 			_return = matches[0] //
	// 				.replace('return', '') //
	// 				.replace(';', '') //
	// 				.replace('this', 'service') //
	// 				.trim();
	// 		}
	// 		var out = '';
	// 		if (Config.IS_DEBUG) {
	// 			out += '// Test with return type `${func.returnValue.type}`\n\t';
	// 			out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
	// 		}
	// 		out += 'it(\'${getTitle(func)}\', () => {
	// 		// Arrange
	// 		${createVarFromFunctionParam(func.params)}
	// 		const _${func.returnValue.type}: ${func.returnValue.type} = (${_return}); // true;
	// 		const result: ${func.returnValue.type} = service.${func.name}(${_param});
	// 		const spy = spyOn(service, \'${func.name}\').and.returnValue(_${func.returnValue.type});
	// 		// Act
	// 		service.${func.name}(${_param});
	// 		// Assert
	// 		expect(result).toBe(_${func.returnValue.type});
	// 		expect(result).toBeTruthy();
	// 		expect(spy).toHaveBeenCalled();
	// 		expect(service.${func.name}(${_param})).toBeTruthy();
	// 		expect(spy).toHaveBeenCalledTimes(2);
	// 		expect(service.${func.name}(${_param})).toBeTrue();
	// 		expect(spy).toHaveBeenCalledTimes(3);
	// 		expect(service.${func.name}).toBeDefined();
	// 	});
	// ';
	// 		return out;
	// 	}
	// 	function createTestNumber(func:FuncObj):String {
	// 		var _param = convertFuncObjParam2String(func);
	// 		// get return .... test!
	// 		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
	// 		var _return = '1';
	// 		if (matches[0] != null) {
	// 			_return = matches[0] //
	// 				.replace('return', '') //
	// 				.replace(';', '') //
	// 				.replace('this', 'service') //
	// 				.trim();
	// 		}
	// 		var out = '';
	// 		if (Config.IS_DEBUG) {
	// 			out += '// Test with return type `${func.returnValue.type}`\n\t';
	// 			out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
	// 		}
	// 		out += 'it(\'${getTitle(func)}\', () => {
	// 		// Arrange
	// 		${createVarFromFunctionParam(func.params)}
	// 		const _${func.returnValue.type}: ${func.returnValue.type} = ${_return}; // ${GenValues.number()};
	// 		const result: ${func.returnValue.type} = service.${func.name}(${_param});
	// 		const spy = spyOn(service, \'${func.name}\').and.returnValue(_${func.returnValue.type});
	// 		// Act
	// 		service.${func.name}(${_param});
	// 		// Assert
	// 		expect(result).toBe(_${func.returnValue.type});
	// 		expect(spy).toHaveBeenCalled();
	// 		expect(service.${func.name}(${_param})).toBeTruthy();
	// 		expect(spy).toHaveBeenCalledTimes(2);
	// 		expect(service.${func.name}).toBeDefined();
	// 	});
	// ';
	// 		return out;
	// 	}
	// 	function createTestUnknown(func:FuncObj):String {
	// 		var _param = convertFuncObjParam2String(func);
	// 		// get return .... test!
	// 		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
	// 		var _return = '{}';
	// 		if (matches[0] != null) {
	// 			_return = matches[0] //
	// 				.replace('return', '') //
	// 				.replace(';', '') //
	// 				.replace('this', 'service') //
	// 				.trim();
	// 		}
	// 		var out = '';
	// 		out += '// Test with return type `${func.returnValue.type}` (UNKNOWN)\n\t';
	// 		// out += '// [WIP] test is default disabled (`xit`) \n\t';
	// 		out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
	// 		if (Config.IS_DEBUG) {}
	// 		out += 'it(\'${getTitle(func)}\', () => {
	// 		// Arrange
	// 		${createVarFromFunctionParam(func.params)}
	// 		const _${func.returnValue.type.toLowerCase()}: ${func.returnValue.type} = ${_return};
	// 		const result: ${func.returnValue.type} = service.${func.name}(${_param});
	// 		const spy = spyOn(service, \'${func.name}\').and.returnValue(_${func.returnValue.type.toLowerCase()});
	// 		// Act
	// 		service.${func.name}(${_param});
	// 		// Assert
	// 		expect(service.${func.name}).toBeDefined();
	// 		expect(result).toBeTruthy();
	// 		expect(spy).toHaveBeenCalled();
	// 	});
	// ';
	// 		return out;
	// 	}
	// ____________________________________ getter/setter ____________________________________
	// 	/**
	// 	 * [Description]
	// 	 * @param func
	// 	 * @return String
	// 	 */
	// 	function createTestGetter(func:FuncObj):String {
	// 		var _param = convertFuncObjParam2String(func);
	// 		// get return .... test!
	// 		var _return = '';
	// 		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
	// 		if (matches[0] != null) {
	// 			_return = matches[0] //
	// 				.replace('return', '') //
	// 				.replace(';', '') //
	// 				.replace('this', 'service') //
	// 				.trim();
	// 		}
	// 		// warn(func);
	// 		// warn(createVarFromFunctionParam(func.params));
	// 		var out = '';
	// 		out += '// Test GETTER with return type `${func.returnValue.type}`\n\t';
	// 		// if (Config.IS_DEBUG) {
	// 		// 	out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
	// 		// }
	// 		out += 'it(\'${getTitle(func)}\', () => {
	// 		${createVarFromFunctionParam(func.params)}
	// 		const any: any = ${_return};
	// 		const spy = spyOn(service, \'${func.name}\').and.returnValue(any);
	// 		const result: ${func.returnValue.type} = service.${func.name}(${_param});
	// 		expect(result).toBe(any);
	// 		expect(spy).toHaveBeenCalled();
	// 		// expect(service.${func.name}(${_param})).toBeTruthy();
	// 		// expect(spy).toHaveBeenCalledTimes(2);
	// 		// expect(service.${func.name}(${_param})).toBe(any);
	// 		expect(service.${func.name}).toBeDefined();
	// 	});
	// ';
	// 		return out;
	// 	}
	// 	/**
	// 	 *
	// 	 *
	// 	 * @param func
	// 	 * @return String
	// 	 */
	// 	function createTestSetter(func:FuncObj):String {
	// 		var _param = convertFuncObjParam2String(func);
	// 		// get return .... test!
	// 		var _return = '';
	// 		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
	// 		if (matches[0] != null) {
	// 			_return = matches[0] //
	// 				.replace('return', '') //
	// 				.replace(';', '') //
	// 				.replace('this', 'service') //
	// 				.trim();
	// 		}
	// 		var out = '';
	// 		// out += '// ${haxe.Json.stringify(func)}';
	// 		out += '// Test SETTER with return type `${func.returnValue.type}`\n\t';
	// 		// if (Config.IS_DEBUG) {
	// 		// 	out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
	// 		// }
	// 		out += 'it(\'${getTitle(func)}\', () => {
	// 		// Arrange
	// 		${createVarFromFunctionParam(func.params)}
	// 		const spy = spyOn(service, \'${func.name}\').and.returnValue(${_return});
	// 		// Act
	// 		service.${func.name}(${_param});
	// 		// Assert
	// 		const result: ${func.params[0].type} = service.${func.name.replace('set', 'get')}();
	// 		expect(result).toEqual(${func.params[0].name});
	// 		expect(spy).toHaveBeenCalled();
	// 		expect(service.${func.name}).toBeDefined();
	// 	});
	// ';
	// 		return out;
	// 	}
	// ____________________________________ misc/tools ____________________________________
	// /**
	//  * convert params to string to use in call function
	//  * ```ts
	//  * service.func(param);
	//  * ```
	//  *
	//  * @param func
	//  * @return String
	//  */
	// function convertFuncObjParam2String(func:FuncObj):String {
	// 	var _param = '';
	// 	for (i in 0...func.params.length) {
	// 		var _p = func.params[i];
	// 		_param += '${_p.name}';
	// 		if ((i + 1) < func.params.length) {
	// 			_param += ', ';
	// 		}
	// 	}
	// 	return _param;
	// }
	// /**
	//  * [WARNING] very specific for project
	//  *
	//  * @param params
	//  * @return String
	//  */
	// function createVarFromFunctionParam(params:Array<TypedObj>):String {
	// 	var out = '';
	// 	var isArray = false;
	// 	var isUnion = false;
	// 	var gen = '[]';
	// 	for (i in 0...params.length) {
	// 		var _p = params[i];
	// 		// log(_p);
	// 		isArray = (_p.type.indexOf('[]') != -1) ? true : false;
	// 		isUnion = (_p.type.indexOf('|') != -1) ? true : false;
	// 		switch (_p.type) {
	// 			case '{ id': // FIXME bug
	// 				out += 'const id = 0;';
	// 			case 'bool', 'boolean', 'Boolean':
	// 				out += 'const ${_p.name}: ${_p.type} = true;';
	// 			case 'number':
	// 				out += 'const ${_p.name}: ${_p.type} = 0;';
	// 			case 'string':
	// 				out += 'const ${_p.name}: ${_p.type} = "";';
	// 			case 'any', 'object':
	// 				out += 'const ${_p.name}: ${_p.type} = {};';
	// 			case 'ILightSchedule':
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		astronomicalSunriseOffset: 0,
	// 		astronomicalSunsetOffset: 0,
	// 		code: \'\',
	// 		color: \'\',
	// 		defaultSchedule: false,
	// 		description: \'\',
	// 		id: 0,
	// 		name: \'\',
	// 		relayFunctions: [],
	// 		scheduleEntries: [],
	// 		success: false,
	// 		superUser: false,
	// 		template: false,
	// 		usedByDevice: false,
	// 		usedByGroup: false,
	// 		usedBySubstation: false
	// 	};';
	// 			case 'IValidate':
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		success: false,
	// 		description: \'\',
	// 		savable: false
	// 	};';
	// 			case 'ISchedulesDetail[]':
	// 				out += 'const ${_p.name.replace('[]', '')}: ${_p.type} = [{
	// 		id: 0,
	// 		name: \'\',
	// 		description: \'\',
	// 		color: \'\',
	// 		code: \'\',
	// 		usedByDevice: false,
	// 		usedByGroup: false,
	// 		usedBySubstation: false,
	// 		defaultSchedule: false,
	// 		success: false,
	// 		template: false,
	// 		superUser: false,
	// 		astronomicalSunriseOffset: 0,
	// 		astronomicalSunsetOffset: 0,
	// 		scheduleEntries: [],
	// 		relayFunctions: []
	// 	}];';
	// 			case 'ISchedulesDetail':
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		id: 0,
	// 		name: \'\',
	// 		description: \'\',
	// 		color: \'\',
	// 		code: \'\',
	// 		usedByDevice: false,
	// 		usedByGroup: false,
	// 		usedBySubstation: false,
	// 		defaultSchedule: false,
	// 		success: false,
	// 		template: false,
	// 		superUser: false,
	// 		astronomicalSunriseOffset: 0,
	// 		astronomicalSunsetOffset: 0,
	// 		scheduleEntries: [],
	// 		relayFunctions: []
	// 	};';
	// 			case 'IUser':
	// 				// make sure we don't have to do this over and over
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		username: \'\',
	// 		roles: {
	// 			ROLE_ADMIN: true,
	// 			ROLE_MANAGER: true,
	// 			ROLE_READONLY: true,
	// 		},
	// 		token: \'\',
	// 		organisation: \'\',
	// 		domains: {
	// 			TARIFF_SWITCHING: true,
	// 			COMMON: true,
	// 			PUBLIC_LIGHTING: true,
	// 		},
	// 		substationManagement: false
	// 	};';
	// 			case 'ISettings':
	// 				// make sure we don't have to do this over and over
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		organisationLocationLatitude: 0,
	// 		organisationLocationLongitude: 0,
	// 		organisationPrefix: \'\',
	// 		privacyStatementFile: \'\',
	// 		scheduleCodeSeed: 0
	// 	};';
	// 			case 'ISort':
	// 				// make sure we don't have to do this over and over
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		sortDir: SortDirectionEnum.ASC,
	// 		sortedBy: SortedByEnum.CODE
	// 	};';
	// 			case 'IPagination':
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		totalItems: 0,
	// 		pageNumber: 0,
	// 		pageSize: 0
	// 	};';
	// 			case 'IBanner':
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		startDate: \'\',
	// 		endDate: \'\',
	// 		url: \'\',
	// 		message: \'\',
	// 	};';
	// 			case 'ISchedules':
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		contents: [],
	// 		pageSize: 0,
	// 		totalItems: 0,
	// 		totalPages: 0
	// 	};';
	// 			case 'ISortedData':
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		currentPage: 0,
	// 		pageSize: 0,
	// 		sortDir: SortDirectionEnum.ASC,
	// 		sortedBy: SortedByEnum.CODE
	// 	};';
	// 			case 'IPage':
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		contents: [],
	// 		totalItems: 0,
	// 		totalPages: 0,
	// 		pageSize: 0
	// 	};';
	// 			case 'IHelp':
	// 				out += 'const ${_p.name}: ${_p.type} = {
	// 		url: \'\'
	// 	};';
	// 			case 'IGroup':
	// 				out += 'const ${_p.name}: ${_p.type} =  {
	// 		id: 0,
	// 		organisationIdentification: \'\',
	// 		groupIdentification: \'\',
	// 		description: \'\',
	// 		deviceIdentifications: [],
	// 		lightSchedule: null,
	// 		tariffSchedule: null,
	// 		lightMeasurementDevice: null,
	// 		groupType: 0,
	// 		deviceFilter: null
	// 	};';
	// 			case 'ISchedulesContent':
	// 				out += 'const ${_p.name}: ${_p.type} =  {
	// 		astronomicalSunriseOffset: 0,
	// 		astronomicalSunsetOffset: 0,
	// 		defaultSchedule: false,
	// 		description: \'\',
	// 		id: 0,
	// 		relayFunctions: [],
	// 		scheduleEntries: [],
	// 		success: false,
	// 		superUser: false,
	// 		template: false,
	// 		usedByDevice: false,
	// 		usedByGroup: false,
	// 		usedBySubstation: false,
	// 		code: \'\',
	// 		color: \'\',
	// 		name: \'\'
	// 	};';
	// 			default:
	// 				out += '\n\t\t// FIXME: add (all) missing properties \n\t\t';
	// 				out += '// const _${_p.name}: ${_p.type} = {};\n\t\t';
	// 				out += '// export const ${_p.name.toUpperCase()}: ${_p.type} = {}; // this var needs to be added to SPEC_CONST\n\t\t';
	// 				out += 'const ${_p.name}: ${_p.type} = SPEC_CONST.getValue(${_p.name.toUpperCase()});\n\t\t';
	// 				trace("case '" + _p.type + "': trace ('" + _p.type + "');");
	// 		}
	// 		out += '\n\t\t';
	// 	}
	// 	return out;
	// }
	// /**
	//  * use the return value of the function to create mock data
	//  *
	//  * @param funcObj
	//  * @param varName
	//  */
	// function getFuncFrom(funcObj:FuncObj, varName:String) {
	// 	// warn(funcObj);
	// 	var varNameReturnValue = funcObj.returnValue.value;
	// 	var varName = funcObj.returnValue.value.toLowerCase().replace('[]', ' ');
	// 	var params = '';
	// 	// loop
	// 	for (i in 0...funcObj.params.length) {
	// 		var _p = funcObj.params[i];
	// 		params += '${_p.name}';
	// 		if ((i + 1) < funcObj.params.length) {
	// 			params += ', ';
	// 		}
	// 	}
	// 	var out = '// create the service call\n';
	// 	// out += '${createVarFromFunctionParam(funcObj.params)}';
	// 	out += '\t\t';
	// 	out += 'service.${funcObj.name}(${params}).subscribe(value => {
	// 		expect(value).toBe(${varName});
	// 		done();
	// 	});';
	// 	return out;
	// }
	// /**
	//  * create a readable description of the test (?)
	//  *
	//  * @param obj
	//  */
	// function getTitle(obj:FuncObj) {
	// 	return '#${obj.name} should return ${obj.returnValue._content}';
	// }
	// ____________________________________ getter/setter ____________________________________

	function get_OBJ():TypeScriptClassObject {
		return OBJ;
	}

	function set_OBJ(value:TypeScriptClassObject):TypeScriptClassObject {
		return OBJ = value;
	}
}
