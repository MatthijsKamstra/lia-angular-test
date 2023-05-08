package convert;

import Extract.TypedObj;
import Extract.FuncObj;
import remove.RemoveComment;
import const.Config;
import spec.SpecService;
import haxe.Json;
import utils.GeneratedBy;
import utils.Copyright;

class ConvertService {
	public static var todo = [
		//
		'- [x] add generated message',
		'- [x] add new copyright',
		'- [x] remove old block comment and line comment',
		'- [x] split code/extract code',
		'- [x] extract constructor',
		'- [x] extract constructor param',
		'- [x] extract functions',
		'- [x] extract functions params and types',
		'- [x] extract functions return value',
	];

	/**
	 *
	 *
	 * @param path
	 */
	public static function init(path:String) {
		// read the content of the file
		var originalContent = sys.io.File.getContent(path);
		var originalContentNoComment = RemoveComment.all(originalContent, 'ts');

		// filename
		var originalFileName = Path.withoutDirectory(path);
		var newFileName = originalFileName.replace('.ts', '.spec.ts');
		var className = originalFileName.replace('.service.ts', '');
		// trace(originalFileName);
		// trace(newFileName);

		// parent dir
		var parent = Path.directory(path);

		// start creating the spec of this file/service
		var ts = new SpecService(className);
		// add values
		ts.addVariable('// add vars');
		// add functions
		// ts.addFunction('// add functions');
		// add imports
		// ts.addImport('// add imports');

		// first try for new extract
		Extract.runExtract(originalContentNoComment, originalFileName.replace('.service.ts', ''));
		var OBJ = Extract.OBJ;
		var map:Map<String, String> = Extract.importMap;

		// TODO: if `HttpClient` exists in map, we should add `imports: [HttpClientTestingModule],` otherwise it might not be needed!

		// -----------------------------------------------------------
		// update the imports
		// -----------------------------------------------------------
		// this loop might not be needed, the next loop after this on might be better
		for (i in 0...OBJ.constructor.params.length) {
			var _obj = OBJ.constructor.params[i];
			// trace(_obj.type);
			// trace(map.exists(_obj.type));
			// trace(map);
			if (_obj.type == 'HttpClient') {
				// probably don't need that
				continue;
			}
			if (map.exists(_obj.type)) {
				ts.addImport('${map.get(_obj.type)}');
			}
		}
		// There are some imports that are not needed, exclude them and show the rest
		ts.addImport('// import directly from ${className}Service');
		for (i in 0...OBJ.imports.length) {
			var _val = OBJ.imports[i];
			if (_val.indexOf('HttpClient') != -1)
				continue;
			if (_val.indexOf('Observable') != -1)
				continue;
			if (_val.indexOf('Injectable') != -1)
				continue;
			ts.addImport('${_val}');
		}

		// -----------------------------------------------------------
		// update the functions
		// -----------------------------------------------------------
		for (i in 0...OBJ.functions.length) {
			var _func:FuncObj = OBJ.functions[i];
			// trace(_func);
			ts.addFunction('// ${i + 1}. Generated test function of ${_func.name}');

			log('${i}. - title test: ${getTitle(_func)}');

			var varNameReturnValue = _func.returnValue.value;
			var varName = _func.returnValue.value.toLowerCase().replace('[]', '');

			var varValue = getVarValueFromReturnValue(_func.returnValue);

			var funcValue = getFuncFrom(_func, varName);
			var funcVarValue = getVarValueFrom(_func, varName);

			var funcURL = 'const ${OBJ.URL != "" ? OBJ.URL : ""} // url used in class';
			if (_func.URL != '') {
				funcURL = 'const ${_func.URL != "" ? _func.URL : ""}';
			}

			var testOut = '
	it(\'${getTitle(_func)}\', (done: DoneFn) => {

		${funcURL}

		${varValue}

		${funcVarValue}

		${funcValue}

		const mockReq = httpMock.expectOne(url);
		expect(mockReq.request.url).toBe(url);
		expect(mockReq.request.method).toBe("${(_func.isGET) ? "GET" : "POST"}");
		expect(mockReq.cancelled).toBeFalsy();
		expect(mockReq.request.responseType).toEqual(\'json\');
		mockReq.flush(${varName});
	});
';

			ts.addFunction(testOut);
		}

		// default typescript template
		var content:String = //
			GeneratedBy.message('ts') //
			+ '\n\n' //
			+ Copyright.init('ts') //
			+ '\n\n' //
			+ ts.create() //
			+ '\n\n';
		// + '/**\n\n${originalContentNoComment}\n\n*/';

		// trace(originalFileName);
		// trace(newFileName);
		// // trace(ts);
		// // trace(content);
		// trace(path);
		// trace(parent);

		var templatePath = '${parent}/${newFileName}';
		if (!Config.IS_OVERWRITE) {
			// create a name that is destincable from orignal file
			templatePath = '${parent}/${newFileName.replace('.spec', '_gen_.spec')}';
		}

		if (Config.IS_DRYRUN) {
			info('DRYRUN: write ${templatePath.split('/src')[1]}', 2);
		} else {
			sys.io.File.saveContent(templatePath, content);
		}

		// warn('${Emoji.x} ${Type.getClassName(ConvertService)} ${path}');
	}

	/**
	 * [Description]
	 * @param funcObj
	 * @param varName
	 */
	static function getVarValueFrom(funcObj:FuncObj, varName:String) {
		// warn(funcObj);

		if (funcObj.params[0] == null)
			return '';

		var gen = '{}'; // start as an object
		var varNameReturnValue = funcObj.name;
		var varName = funcObj.name.toLowerCase().replace('[]', '');

		var isArray = funcObj.name.indexOf('[]') != -1;
		if (isArray)
			gen = '[]'; // ha! it doesn't seem to be and object

		// var params = '';
		// if (funcObj.params[0] != null)
		// 	params = '${funcObj.params[0].name.toLowerCase()}';

		var out = '// FIXME: use "add missing properties"\n';
		out += '\t\t';
		out += 'const ${funcObj.params[0].name.toLowerCase()}: ${funcObj.params[0].type} = ${gen};';
		return out;
	}

	/**
	 *
	 *
	 * @param arg0
	 */
	static function getFuncFrom(funcObj:FuncObj, varName:String) {
		// warn(funcObj);

		var varNameReturnValue = funcObj.returnValue.value;
		var varName = funcObj.returnValue.value.toLowerCase().replace('[]', '');

		var params = '';
		if (funcObj.params[0] != null)
			params = '${funcObj.params[0].name.toLowerCase()}';

		var out = '// generate the service call\n';
		out += '\t\t';
		out += 'service.${funcObj.name}(${params}).subscribe(value => {
			expect(value).toBe(${varName});
			done();
		});';
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
	static function getVarValueFromReturnValue(obj:TypedObj) {
		// warn(obj);

		var gen = '{}'; // start as an object
		var varNameReturnValue = obj.value;
		var varName = obj.value.toLowerCase().replace('[]', '');

		var isArray = obj.value.indexOf('[]') != -1;
		if (isArray)
			gen = '[]'; // ha! it doesn't seem to be and object

		var out = '';
		if (!isArray)
			out += '// FIXME: use "add missing properties"\n\t\t';

		out += 'const ${varName}: ${varNameReturnValue} = ${gen};';
		return out;
	}

	/**
	 * create a readable description of the test (?)
	 *
	 * @param obj
	 */
	static function getTitle(obj:FuncObj) {
		return '#${obj.name} should return ${obj.returnValue._string}';
	}
}
