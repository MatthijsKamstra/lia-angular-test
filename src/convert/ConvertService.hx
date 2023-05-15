package convert;

import haxe.macro.Expr.ExprOf;
import utils.RegEx;
import AST;
import const.Config;
import remove.RemoveComment;
import spec.SpecService;
import utils.Copyright;
import utils.GeneratedBy;

class ConvertService {
	/**
	 * constructor
	 * @param path to original file (at this moment probably a service)
	 */
	public function new(path:String) {
		// read the content of the file
		var originalContent = sys.io.File.getContent(path);
		var originalContentNoComment = RemoveComment.all(originalContent, 'ts');

		// filename
		var originalFileName = Path.withoutDirectory(path);
		var newFileName = originalFileName.replace('.ts', '.spec.ts');
		var className = originalFileName.replace('.service.ts', '');

		// parent dir
		var parent = Path.directory(path);

		// start creating the spec of this file/service
		var ts = new SpecService(className);
		// add values
		// ts.addVariable('// add vars');
		// add functions
		// ts.addFunction('// add functions');
		// add imports
		// ts.addImport('// add imports');

		// first try for new extract
		Extract.runExtract(originalContentNoComment, originalFileName.replace('.service.ts', ''));
		var OBJ = Extract.OBJ;
		// var map:Map<String, String> = Extract.importMap;

		// TODO: if `HttpClient` exists in map, we should add `imports: [HttpClientTestingModule],` otherwise it might not be needed!

		// -----------------------------------------------------------
		// update class vars
		// -----------------------------------------------------------

		// -----------------------------------------------------------
		// update constructor
		// -----------------------------------------------------------
		// log(OBJ.constructor);
		// ts.addConstructor('// constructor');
		for (i in 0...OBJ.constructor.params.length) {
			var _constructor = OBJ.constructor.params[i];
			// trace(_constructor);
			if (_constructor.type.indexOf('HttpClient') != -1)
				continue;
			ts.addConstructor('\tlet ${_constructor.name}: ${_constructor.type};');
			ts.addTestbed('\t\t${_constructor.name} = TestBed.inject(${_constructor.type});');
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
		// update the functions
		// -----------------------------------------------------------
		for (i in 0...OBJ.functions.length) {
			var _func:FuncObj = OBJ.functions[i];
			// trace(_func);
			ts.addFunction('// ${i + 1}. Generated test for "${_func.name}"');

			log('${i}. - title test: ${getTitle(_func)}');

			var isGetter:Bool = (_func.name.indexOf('get') != -1) ? true : false;
			var isSetter:Bool = (_func.name.indexOf('set') != -1) ? true : false;
			var isObservable:Bool = (_func._content.indexOf('Observable') != -1) ? true : false;
			// warn('is this func a getter: ' + isGetter);
			// warn('is this func a setter: ' + isSetter);
			// warn('is this func a isObservable: ' + isObservable);

			if ((isGetter || isSetter) && !isObservable) {
				// warn('getter/setter');
				if (isGetter) {
					mute('use getter test with return value "${_func.returnValue.type}"');
					ts.addFunction(createTestGetter(_func));
				}
				if (isSetter) {
					mute('use setter test with return value "${_func.returnValue.type}"');
					ts.addFunction(createTestSetter(_func));
				}
			} else {
				// warn('return type');
				// warn(_func.returnValue);
				// trace(_func.returnValue.type, _func.name);
				switch (_func.returnValue.type) {
					case 'void':
						mute('use test with return value "void"');
						ts.addFunction(createTestvoid(_func));
					case 'string', 'string | undefined':
						mute('use test with return value "string"');
						ts.addFunction(createTestString(_func));
					case 'Observable':
						mute('use test with return value "Observable"');
						ts.addFunction(createTestObservable(_func));
					case 'boolean', 'Boolean':
						mute('use test with return value "boolean"');
						ts.addFunction(createTestboolean(_func));
					case 'number':
						mute('use test with return value "number"');
						ts.addFunction(createTestNumber(_func));
					default:
						warn("case '" + _func.returnValue.type + "': mute('use test with return value \"" + _func.returnValue.type
							+ "\"'); ts.addFunction(createTest" + _func.returnValue.type + "(_func));");
						ts.addFunction(createTestUnknown(_func));
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
		if (!Config.IS_OVERWRITE) {
			// create a name that is destincable from orignal file
			templatePath = '${parent}/${newFileName.replace('.spec', '_gen_.spec')}';
		}

		if (Config.IS_DRYRUN) {
			info('DRYRUN: write ${templatePath.split('/src')[1]}', 2);
		} else {
			info('Open original file: ${path}', 2);
			info('Open generated test file: ${templatePath}', 2);
			sys.io.File.saveContent(templatePath, content.replace('\n\t\n', '\n'));
		}

		// warn('${Emoji.x} ${Type.getClassName(ConvertService)} ${path}');
	}

	// ____________________________________ create test based upon return type ____________________________________

	/**
	 * disabled test, without guessing
	 *
	 * @param func
	 * @return String
	 */
	function createTestDisabled(func:FuncObj):String {
		var out = '';
		out += '// Test with return type `${func.returnValue.type}`\n\t';
		out += '// [WIP] test is default disabled (`xit`) \n\t';
		out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
		out += 'xit(\'${getTitle(func)}\', () => {
		// expect(result).toBe(true);
		expect(service.${func.name}).toBeDefined();
	});
';
		return out;
	}

	function createTestObservable(func:FuncObj):String {
		var out = '';
		out += '// Test with return type `Observable`\n\t';
		// 	out += 'it(\'${getTitle(func)}\', () => {
		// 	expect(true).toBe(true);
		// });';

		var varNameReturnValue = func.returnValue.value;
		var varName = func.returnValue.value.toLowerCase().replace('[]', ' ');

		// var varValue = getVarValueFromReturnValue(func.returnValue);

		// TODO: maybe the return value of a function needs to better defined
		// for now an quick and dirty fix
		var __temp:Array<TypedObj> = [
			{
				name: '${func.returnValue.value.toLowerCase()}',
				value: '',
				type: '${func.returnValue.value}',
				_content: ''
			}
		];

		var funcValue = getFuncFrom(func, varName);

		var funcURL = '// URL used in class\n\t\t';
		// var funcURL = ' const${OBJ.URL != "" ? OBJ.URL : ""} // url used in class';

		if (func.URL != '') {
			funcURL += 'const ${func.URL != "" ? func.URL : ""}';
		}

		out += 'it(\'${getTitle(func)}\', (done: DoneFn) => {

		// Arrange
		${createVarFromFunctionParam(func.params)}

		${createVarFromFunctionParam(__temp)}

		${funcURL}

		// Act
		${funcValue}

		// Assert
		const mockReq = httpMock.expectOne(url);
		expect(mockReq.request.url).toBe(url);
		expect(mockReq.request.method).toBe("${(func.requestType)}");
		expect(mockReq.cancelled).toBeFalsy();
		expect(mockReq.request.responseType).toEqual(\'json\');
		mockReq.flush(${varName});
	});
';

		return out;
	}

	function createTestvoid(func:FuncObj):String {
		var _param = convertFuncObjParam2String(func);

		var out = '';
		// out += '// Test with return type `${func.returnValue.type}`\n\t';
		// out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
		out += 'it(\'${getTitle(func)}\', () => {
		${createVarFromFunctionParam(func.params)}
		const spy = spyOn(service, \'${func.name}\');
		const result = service.${func.name}(${_param});
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.${func.name}).toBeDefined();
	});
';

		return out;
	}

	function createTestString(func:FuncObj):String {
		var _param = convertFuncObjParam2String(func);

		// get return .... test!
		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
		var _return = '';
		if (matches[0] != null) {
			_return = matches[0] //
				.replace('return', '') //
				.replace(';', '') //
				.replace('this', 'service') //
				.trim();
		}

		var out = '';
		// out += '// Test with return type `${func.returnValue.type}`\n\t';
		// out += '// [WIP] test is default disabled (`xit`) \n\t';
		// out += '// [mck] weird stuff here, this should work\n\t';
		// out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
		out += 'it(\'${getTitle(func)}\', () => {
		${createVarFromFunctionParam(func.params)}
		const str = ${_return};
		const spy = spyOn(service, \'${func.name}\').and.returnValue(${_return});
		const result: ${func.returnValue.type} = service.${func.name}(${_param});
		expect(result).toBe(${_return});
		expect(spy).toHaveBeenCalled();
		expect(service.${func.name}(${_param})).toBe(${_return});
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.${func.name}(${_param})).toContain(${_return});
		expect(spy).toHaveBeenCalledTimes(3);
		expect(service.${func.name}(${_param})).toBe(str);
		expect(spy).toHaveBeenCalledTimes(4);
		expect(service.${func.name}).toBeDefined();
	});
';
		return out;
	}

	function createTestboolean(func:FuncObj):String {
		var _param = convertFuncObjParam2String(func);

		// get return .... test!
		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
		var _return = '';
		if (matches[0] != null) {
			_return = matches[0] //
				.replace('return', '') //
				.replace(';', '') //
				.replace('this', 'service') //
				.trim();
		}

		var out = '';
		// out += '// Test with return type `${func.returnValue.type}`\n\t';
		// out += '// [mck] weird stuff here, this should work\n\t';
		// out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
		out += 'it(\'${getTitle(func)}\', () => {
		${createVarFromFunctionParam(func.params)}
		const spy = spyOn(service, \'${func.name}\').and.returnValue(${_return});
		const result: ${func.returnValue.type} = service.${func.name}(${_param});
		expect(result).toBe(${_return});
		expect(result).toBeTruthy();
		expect(spy).toHaveBeenCalled();
		expect(service.${func.name}(${_param})).toBeTruthy();
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.${func.name}(${_param})).toBeTrue();
		expect(spy).toHaveBeenCalledTimes(3);
		expect(service.${func.name}).toBeDefined();
	});
';

		return out;
	}

	function createTestNumber(func:FuncObj):String {
		var _param = convertFuncObjParam2String(func);

		// get return .... test!
		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
		var _return = '';
		if (matches[0] != null) {
			_return = matches[0] //
				.replace('return', '') //
				.replace(';', '') //
				.replace('this', 'service') //
				.trim();
		}

		var out = '';
		// out += '// Test with return type `${func.returnValue.type}`\n\t';
		// out += '// [mck] weird stuff here, this should work\n\t';
		// out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
		out += 'it(\'${getTitle(func)}\', () => {
		${createVarFromFunctionParam(func.params)}
		const spy = spyOn(service, \'${func.name}\').and.returnValue(${_return});
		const result: ${func.returnValue.type} = service.${func.name}(${_param});
		expect(result).toBe(${_return});
		expect(spy).toHaveBeenCalled();
		expect(service.${func.name}(${_param})).toBeTruthy();
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.${func.name}).toBeDefined();
	});
';

		return out;
	}

	function createTestUnknown(func:FuncObj):String {
		var _param = convertFuncObjParam2String(func);

		// get return .... test!
		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
		var _return = '';
		if (matches[0] != null) {
			_return = matches[0] //
				.replace('return', '') //
				.replace(';', '') //
				.replace('this', 'service') //
				.trim();
		}

		var out = '';
		out += '// Test with return type `${func.returnValue.type}` (UNKNOWN)\n\t';
		// out += '// [WIP] test is default disabled (`xit`) \n\t';
		out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';

		out += 'it(\'${getTitle(func)}\', () => {
		${createVarFromFunctionParam(func.params)}
		// const spy = spyOn(service, \'${func.name}\').and.returnValue(${_return});
		const result: ${func.returnValue.type} = service.${func.name}(${_param});
		expect(service.${func.name}).toBeDefined();
		// expect(spy).toHaveBeenCalled();
	});
';
		return out;
	}

	/**
	 * [Description]
	 * @param func
	 * @return String
	 */
	function createTestGetter(func:FuncObj):String {
		var _param = convertFuncObjParam2String(func);

		// get return .... test!
		var _return = '';
		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
		if (matches[0] != null) {
			_return = matches[0] //
				.replace('return', '') //
				.replace(';', '') //
				.replace('this', 'service') //
				.trim();
		}

		// warn(func);
		// warn(createVarFromFunctionParam(func.params));

		var out = '';
		out += '// Test GETTER with return type `${func.returnValue.type}`\n\t';
		// out += '// [WIP] test is default disabled (change `xit` to `it` to activate) \n\t';
		out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';
		out += 'it(\'${getTitle(func)}\', () => {
		${createVarFromFunctionParam(func.params)}
		const result: ${func.returnValue.type} = service.${func.name}(${_param});
		expect(result).toBe(${_return});
		expect(service.${func.name}).toBeDefined();
	});
';
		return out;
	}

	/**
	 *
	 *
	 * @param func
	 * @return String
	 */
	function createTestSetter(func:FuncObj):String {
		var _param = convertFuncObjParam2String(func);

		// get return .... test!
		var _return = '';
		var matches = RegEx.getMatches(RegEx.getReturn, func._content);
		if (matches[0] != null) {
			_return = matches[0] //
				.replace('return', '') //
				.replace(';', '') //
				.replace('this', 'service') //
				.trim();
		}

		var out = '';
		// out += '// ${haxe.Json.stringify(func)}';
		out += '// Test SETTER with return type `${func.returnValue.type}`\n\t';
		// out += '// [WIP] test is default disabled (change `xit` to `it` to activate) \n\t';
		out += '/**\n\t *\t${func._content.replace('\n', '\n\t *\t')}\n\t */\n\t';

		out += 'it(\'${getTitle(func)}\', () => {
		// Arrange
		${createVarFromFunctionParam(func.params)}

		// Act
		service.${func.name}(${_param});

		// Assert
		const result: ${func.params[0].type} = service.${func.name.replace('set', 'get')}();
		expect(result).toBe(${func.params[0].name});
		expect(service.${func.name}).toBeDefined();
	});
';

		return out;
	}

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
	 * [WARNING] very specific for project
	 *
	 * @param params
	 * @return String
	 */
	function createVarFromFunctionParam(params:Array<TypedObj>):String {
		var out = '';
		var isArray = false;
		var gen = '[]';
		for (i in 0...params.length) {
			var _p = params[i];
			log(_p);
			if (_p.type.indexOf('[]') != -1)
				isArray = true;

			switch (_p.type) {
				case '{ id': // FIXME bug
					out += 'const id = 0;';
				case 'bool', 'boolean', 'Boolean':
					out += 'const ${_p.name}: ${_p.type} = true;';
				case 'number':
					out += 'const ${_p.name}: ${_p.type} = 0;';
				case 'string':
					out += 'const ${_p.name}: ${_p.type} = "";';
				case 'any', 'object':
					out += 'const ${_p.name}: ${_p.type} = {};';
				case 'ILightSchedule':
					out += 'const ${_p.name}: ${_p.type} = {
			astronomicalSunriseOffset: 0,
			astronomicalSunsetOffset: 0,
			code: \'\',
			color: \'\',
			defaultSchedule: false,
			description: \'\',
			id: 0,
			name: \'\',
			relayFunctions: [],
			scheduleEntries: [],
			success: false,
			superUser: false,
			template: false,
			usedByDevice: false,
			usedByGroup: false,
			usedBySubstation: false
		};';
				case 'IValidate':
					out += 'const ${_p.name}: ${_p.type} = {
			success: false,
			description: \'\',
			savable: false
		};';

				case 'ISchedulesDetail[]':
					out += 'const ${_p.name.replace('[]', '')}: ${_p.type} = [{
			id: 0,
			name: \'\',
			description: \'\',
			color: \'\',
			code: \'\',
			usedByDevice: false,
			usedByGroup: false,
			usedBySubstation: false,
			defaultSchedule: false,
			success: false,
			template: false,
			superUser: false,
			astronomicalSunriseOffset: 0,
			astronomicalSunsetOffset: 0,
			scheduleEntries: [],
			relayFunctions: []
		}];';

				case 'ISchedulesDetail':
					out += 'const ${_p.name}: ${_p.type} = {
			id: 0,
			name: \'\',
			description: \'\',
			color: \'\',
			code: \'\',
			usedByDevice: false,
			usedByGroup: false,
			usedBySubstation: false,
			defaultSchedule: false,
			success: false,
			template: false,
			superUser: false,
			astronomicalSunriseOffset: 0,
			astronomicalSunsetOffset: 0,
			scheduleEntries: [],
			relayFunctions: []
		};';

				case 'IUser':
					// make sure we don't have to do this over and over
					out += 'const ${_p.name}: ${_p.type} = {
			username: \'\',
			roles: {
				ROLE_ADMIN: true,
				ROLE_MANAGER: true,
				ROLE_READONLY: true,
			},
			token: \'\',
			organisation: \'\',
			domains: {
				TARIFF_SWITCHING: true,
				COMMON: true,
				PUBLIC_LIGHTING: true,
			},
			substationManagement: false
		};';
				case 'ISettings':
					// make sure we don't have to do this over and over
					out += 'const ${_p.name}: ${_p.type} = {
			organisationLocationLatitude: 0,
			organisationLocationLongitude: 0,
			organisationPrefix: \'\',
			privacyStatementFile: \'\',
			scheduleCodeSeed: 0
		};';
				case 'ISort':
					// make sure we don't have to do this over and over
					out += 'const ${_p.name}: ${_p.type} = {
			sortDir: SortDirectionEnum.ASC,
			sortedBy: SortedByEnum.CODE
		};';
				case 'IPagination':
					out += 'const ${_p.name}: ${_p.type} = {
			totalItems: 0,
			pageNumber: 0,
			pageSize: 0
		};';
				case 'IBanner':
					out += 'const ${_p.name}: ${_p.type} = {
			startDate: \'\',
			endDate: \'\',
			url: \'\',
			message: \'\',
		};';
				case 'ISchedules':
					out += 'const ${_p.name}: ${_p.type} = {
			contents: [],
			pageSize: 0,
			totalItems: 0,
			totalPages: 0
		};';
				case 'ISortedData':
					out += 'const ${_p.name}: ${_p.type} = {
			currentPage: 0,
			pageSize: 0,
			sortDir: SortDirectionEnum.ASC,
			sortedBy: SortedByEnum.CODE
		};';
				case 'IPage':
					out += 'const ${_p.name}: ${_p.type} = {
			contents: [],
			totalItems: 0,
			totalPages: 0,
			pageSize: 0
		};';
				case 'IHelp':
					out += 'const ${_p.name}: ${_p.type} = {
			url: \'\'
		};';
				case 'IGroup':
					out += 'const ${_p.name}: ${_p.type} =  {
			id: 0,
			organisationIdentification: \'\',
			groupIdentification: \'\',
			description: \'\',
			deviceIdentifications: [],
			lightSchedule: null,
			tariffSchedule: null,
			lightMeasurementDevice: null,
			groupType: 0,
			deviceFilter: null
		};';
				case 'ISchedulesContent':
					out += 'const ${_p.name}: ${_p.type} =  {
			astronomicalSunriseOffset: 0,
			astronomicalSunsetOffset: 0,
			defaultSchedule: false,
			description: \'\',
			id: 0,
			relayFunctions: [],
			scheduleEntries: [],
			success: false,
			superUser: false,
			template: false,
			usedByDevice: false,
			usedByGroup: false,
			usedBySubstation: false,
			code: \'\',
			color: \'\',
			name: \'\'
		};';
				default:
					// TODO check array, object, etc
					out += '// FIXME: add (all) missing properties \n\t\t';
					out += 'const ${_p.name}: ${_p.type} = {};\n\t\t';
					trace("case '" + _p.type + "': trace ('" + _p.type + "');");
			}
		}

		return out;
	}

	/**
	 * use the return value of the function to create mock data
	 *
	 * @param funcObj
	 * @param varName
	 */
	function getFuncFrom(funcObj:FuncObj, varName:String) {
		// warn(funcObj);

		var varNameReturnValue = funcObj.returnValue.value;
		var varName = funcObj.returnValue.value.toLowerCase().replace('[]', ' ');

		var params = '';
		// loop
		for (i in 0...funcObj.params.length) {
			var _p = funcObj.params[i];
			params += '${_p.name}';
			if ((i + 1) < funcObj.params.length) {
				params += ', ';
			}
		}

		var out = '// create the service call\n';
		// out += '${createVarFromFunctionParam(funcObj.params)}';
		out += '\t\t';
		out += 'service.${funcObj.name}(${params}).subscribe(value => {
			expect(value).toBe(${varName});
			done();
		});';
		return out;
	}

	// /**
	//  * get the values used in the functions (param)
	//  *
	//  * @param funcObj
	//  * @param varName
	//  */
	// function getVarValueFrom(funcObj:FuncObj, varName:String) {
	// 	// warn(funcObj);
	// 	var out = '// FIXME: use "add (all) missing properties" (vars)\n';
	// 	if (funcObj.params[0] == null)
	// 		return '';
	// 	var gen = '{}'; // start as an object
	// 	// var varNameReturnValue = funcObj.name;
	// 	// var varName = funcObj.name.toLowerCase().replace('[]', '');
	// 	// var isArray = funcObj.name.indexOf('[]') != -1;
	// 	// if (isArray)
	// 	// 	gen = '[]'; // ha! it doesn't seem to be and object
	// 	for (i in 0...funcObj.params.length) {
	// 		var _params = funcObj.params[i];
	// 		switch (_params.type) {
	// 			case 'string':
	// 				// sure what the type is
	// 				gen = '""';
	// 				out = '// (vars)\n';
	// 			default:
	// 				gen = '{}';
	// 				// trace("case '" + _params.type + "': trace ('" + _params.type + "');");
	// 		}
	// 		out += '\t\t';
	// 		out += 'const ${_params.name}: ${_params.type} = ${gen};';
	// 	}
	// 	// var params = '';
	// 	// if (funcObj.params[0] != null)
	// 	// 	params = '${funcObj.params[0].name.toLowerCase()}';
	// 	return out;
	// }
	// /**
	//  * create a const value to use in the tests
	//  *
	//  * @example
	//  * 			`Observable<IHelp>` --> `const ihelp: IHelp = {};`
	//  * 			`Observable<LightMeasurementDevice[]>` --> `const ischedules: ISchedules = {};`
	//  *
	//  * @param TypedObj
	//  */
	// function getVarValueFromReturnValue(obj:TypedObj) {
	// 	// warn(obj);
	// 	var gen = '{}'; // start as an object
	// 	var varNameReturnValue = obj.value;
	// 	var varName = obj.value.toLowerCase().replace('[]', '');
	// 	var isArray = obj.value.indexOf('[]') != -1;
	// 	if (isArray)
	// 		gen = '[]'; // ha! it doesn't seem to be and object
	// 	var out = '';
	// 	if (!isArray)
	// 		out += '// FIXME: use "add (all) missing properties" (return value)\n\t\t';
	// 	out += 'const ${varName}: ${varNameReturnValue} = ${gen};';
	// 	return out;
	// }

	/**
	 * create a readable description of the test (?)
	 *
	 * @param obj
	 */
	function getTitle(obj:FuncObj) {
		return '#${obj.name} should return ${obj.returnValue._content}';
	}
}
