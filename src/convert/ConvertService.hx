package convert;

import Extract.FuncObj;
import Extract.ParamObj;
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
	 * @param source
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

			log('title test: ${getTitle(OBJ.functions[0])}');

			var varNameReturnValue = OBJ.functions[i].returnValue.value;
			var varName = OBJ.functions[i].returnValue.value.toLowerCase().replace('[]', '');

			var varValue = getValueFrom(OBJ.functions[i]);

			var testOut = '
	it(\'${getTitle(OBJ.functions[i])}\', (done: DoneFn) => {

		const ${OBJ.URL != "" ? OBJ.URL : ""}

		${varValue}

		service.getData().subscribe(value => {
			expect(value).toBe(${varName});
			done();
		});

		const mockReq = httpMock.expectOne(url);
		expect(mockReq.request.url).toBe(url);
		expect(mockReq.request.method).toBe("GET");
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

	static function getValueFrom(funcObj:FuncObj) {
		var gen = '{}'; // start as an object
		var varNameReturnValue = funcObj.returnValue.value;
		var varName = funcObj.returnValue.value.toLowerCase().replace('[]', '');

		var isArray = funcObj.returnValue.value.indexOf('[]') != -1;
		if (isArray)
			gen = '[]'; // ha! it doesn't seem to be and object

		var out = '';
		if (!isArray)
			out += '// FIXME: use "add missing properties"\n\t\t';

		out += 'const ${varName}: ${varNameReturnValue} = ${gen};';
		return out;
	}

	static function getTitle(obj:FuncObj) {
		return '#${obj.name} should return ${obj.returnValue.string}';
	}
}
