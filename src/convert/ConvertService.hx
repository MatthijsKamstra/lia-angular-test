package convert;

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
		// update the imports
		// -----------------------------------------------------------
		ts.addImport('// import directly from ${className}Service');
		for (i in 0...OBJ.imports.length) {
			var _import = OBJ.imports[i];
			// There are some imports that are not needed, exclude them and show the rest
			if (_import.indexOf('HttpClient') != -1) {
				// ignore
				continue;
			}
			if (_import.indexOf('Observable') != -1) {
				// ignore
				continue;
			}
			if (_import.indexOf('Injectable') != -1) {
				// ignore
				continue;
			}
			ts.addImport('${_import}');
		}

		// -----------------------------------------------------------
		// update the functions
		// -----------------------------------------------------------
		for (i in 0...OBJ.functions.length) {
			var _func:FuncObj = OBJ.functions[i];
			// trace(_func);
			ts.addFunction('// ${i + 1}. Generated test function "${_func.name}"');

			log('${i}. - title test: ${getTitle(_func)}');

			// warn(_func.returnValue);
			switch (_func.returnValue.type) {
				case 'void':
					mute('use test with return value "void"');
					ts.addFunction(createTestvoid(_func));
				case 'string':
					mute('use test with return value "string"');
					ts.addFunction(createTestString(_func));
				case 'Observable':
					mute('use test with return value "Observable"');
					ts.addFunction(createTestObservable(_func));
				case 'boolean':
					mute('use test with return value "boolean"');
					ts.addFunction(createTestboolean(_func));
				default:
					warn("case '" + _func.returnValue.type + "': mute('use test with return value \"" + _func.returnValue.type
						+ "\"'); ts.addFunction(createTest" + _func.returnValue.type + "(_func));");
					ts.addFunction(createTestUnknown(_func));
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
			+ '\n\n';
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
			sys.io.File.saveContent(templatePath, content);
		}

		// warn('${Emoji.x} ${Type.getClassName(ConvertService)} ${path}');
	}

	// ____________________________________ create test based upon return type ____________________________________

	function createTestObservable(func:FuncObj):String {
		var out = '// test with return type Observable\n\t';
		// 	out += 'it(\'${getTitle(func)}\', () => {
		// 	expect(true).toBe(true);
		// });';

		var varNameReturnValue = func.returnValue.value;
		var varName = func.returnValue.value.toLowerCase().replace('[]', ' ');

		var varValue = getVarValueFromReturnValue(func.returnValue);

		var funcValue = getFuncFrom(func, varName);
		var funcVarValue = getVarValueFrom(func, varName);

		var funcURL = '// URL used in class\n\t\t';
		// var funcURL = ' const${OBJ.URL != "" ? OBJ.URL : ""} // url used in class';

		if (func.URL != '') {
			funcURL += 'const ${func.URL != "" ? func.URL : ""}';
		}

		out += 'it(\'${getTitle(func)}\', (done: DoneFn) => {

		${varValue}

		${funcVarValue}

		${funcURL}

		${funcValue}

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

	function createTestString(func:FuncObj):String {
		var out = '// test with return type string\n\t';
		out += 'it(\'${getTitle(func)}\', () => {
		// expect(true).toBe(true);
	});
';
		return out;
	}

	function createTestvoid(func:FuncObj):String {
		var out = createTestUnknown(func);
		return out;
	}

	function createTestboolean(func:FuncObj):String {
		var out = createTestUnknown(func);
		return out;
	}

	function createTestUnknown(func:FuncObj):String {
		var out = '// test with return type UNKNOWN ${func.requestType}\n\t';
		out += 'it(\'${getTitle(func)}\', () => {
		// expect(true).toBe(true);
	});
';
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
		var varName = funcObj.returnValue.value.toLowerCase().replace('[]', '');

		var params = '';
		if (funcObj.params[0] != null)
			params = '${funcObj.params[0].name}';

		var out = '// create the service call\n';
		out += '\t\t';
		out += 'service.${funcObj.name}(${params}).subscribe(value => {
			expect(value).toBe(${varName});
			done();
		});';
		return out;
	}

	/**
	 * get the values used in the functions (param)
	 *
	 * @param funcObj
	 * @param varName
	 */
	function getVarValueFrom(funcObj:FuncObj, varName:String) {
		// warn(funcObj);

		var out = '// FIXME: use "add (all) missing properties" (vars)\n';

		if (funcObj.params[0] == null)
			return '';

		var gen = '{}'; // start as an object
		// var varNameReturnValue = funcObj.name;
		// var varName = funcObj.name.toLowerCase().replace('[]', '');

		// var isArray = funcObj.name.indexOf('[]') != -1;
		// if (isArray)
		// 	gen = '[]'; // ha! it doesn't seem to be and object

		for (i in 0...funcObj.params.length) {
			var _params = funcObj.params[i];
			switch (_params.type) {
				case 'string':
					// sure what the type is
					gen = '""';
					out = '// (vars)\n';
				default:
					gen = '{}';
					// trace("case '" + _params.type + "': trace ('" + _params.type + "');");
			}
			out += '\t\t';
			out += 'const ${_params.name}: ${_params.type} = ${gen};';
		}
		// var params = '';
		// if (funcObj.params[0] != null)
		// 	params = '${funcObj.params[0].name.toLowerCase()}';

		return out;
	}

	/**
	 * create a const value to use in the tests
	 *
	 * @example
	 * 			`Observable<IHelp>` --> `const ihelp: IHelp = {};`
	 * 			`Observable<LightMeasurementDevice[]>` --> `const ischedules: ISchedules = {};`
	 *
	 * @param TypedObj
	 */
	function getVarValueFromReturnValue(obj:TypedObj) {
		// warn(obj);

		var gen = '{}'; // start as an object
		var varNameReturnValue = obj.value;
		var varName = obj.value.toLowerCase().replace('[]', '');

		var isArray = obj.value.indexOf('[]') != -1;
		if (isArray)
			gen = '[]'; // ha! it doesn't seem to be and object

		var out = '';
		if (!isArray)
			out += '// FIXME: use "add (all) missing properties" (return value)\n\t\t';

		out += 'const ${varName}: ${varNameReturnValue} = ${gen};';
		return out;
	}

	/**
	 * create a readable description of the test (?)
	 *
	 * @param obj
	 */
	function getTitle(obj:FuncObj) {
		return '#${obj.name} should return ${obj.returnValue._content}';
	}
}
