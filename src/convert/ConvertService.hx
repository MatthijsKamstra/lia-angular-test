package convert;

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
		'- [ ] split code/extract code',
		'- [ ] extract constructor',
		'- [ ] extract constructor param',
		'- [ ] extract functions',
		'- [ ] extract functions params and types',
		'- [ ] extract functions return value',
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
		// remove service (don't need `groups-service.service.ts` as filesnames)
		// var fileName = FileName.convert(Path.withoutDirectory(path).replace('.html', '').replace('.js', '').replace('service', '').replace('Service', ''));
		var newFileName = originalFileName.replace('.ts', '.spec.ts');

		// parent dir
		var parent = Path.directory(path);

		// trace(originalFileName);
		// trace(newFileName);

		var ts = new SpecService(originalFileName.replace('.service.ts', ''));
		// add values
		ts.addVariable('// add vars');
		// add functions
		ts.addFunction('// add functions');
		// add imports
		ts.addImport('// add imports');

		// first try for new extract
		Extract.runExtract(originalContentNoComment, originalFileName.replace('.service.ts', ''));
		var obj = Extract.OBJ;
		var map:Map<String, String> = Extract.importMap;

		for (i in 0...obj.constructor.params.length) {
			var _obj = obj.constructor.params[i];
			// trace(_obj.type);
			// trace(map.exists(_obj.type));
			// trace(map);
			if (map.exists(_obj.type)) {
				ts.addImport('${map.get(_obj.type)}');
			}
		}

		// TODO: crude methode of catching data... I could not find the correct regex to catch all data
		var fArr = [];
		var vArr = [];
		// var fArr = Extract.fromServiceFunctions(originalContent);
		// var vArr = Extract.fromServiceVars(originalContent);

		// info('----> ' + fArr);
		for (j in 0...vArr.length) {
			var item = vArr[j];
			// warn(item);
			ts.addVariable('/**\n ${Json.parse(Json.stringify(item, null, ''))}; \n*/\n\n');
		}

		// info('----> ' + fArr);
		for (j in 0...fArr.length) {
			var item = fArr[j];
			// warn(item);
			// convert string?
			// item = item.replace('"', '');
			// [mck] hacky, hacky, hacky
			item = item.replace(':', '');
			item = item.replace('function', '');
			item = item.replace(',', ':any,');
			item = item.replace(')', ':any)');
			item = item.replace('(:any)', '()');

			var name = item.split('(')[0].trim();

			// ugh...
			// var reg = ~/\((.*)\)/g;
			// var matches = RegEx.getMatches(reg, item);

			// if (matches.length > 0) {
			// 	warn(matches, 2);
			// }

			// ts.addFunction('${item}');

			// // ts.addFunction('public ${item}: any { \r\t\tconsole.log("${name}"); \r\t\treturn true; \r\t}\r\r');
		}

		// default typescript template
		var content:String = //
			GeneratedBy.message('ts')
			+ '\n\n' //
			+ Copyright.init('ts')
			+ '\n\n' //
			+ ts.create()
			+ '\n\n'
			+ '/**\n\n${originalContentNoComment}\n\n*/';

		// trace(originalFileName);
		// trace(newFileName);
		// // trace(ts);
		// // trace(content);
		// trace(path);
		// trace(parent);

		var templatePath = '${parent}/${newFileName}';
		if (!Config.IS_OVERWRITE) {
			// create a name that is destincable from orignal file
			templatePath = '${parent}/${newFileName.replace('.spec', '_.spec')}';
		}

		if (Config.IS_DRYRUN) {
			info('DRYRUN: write ${templatePath.split('/src')[1]}', 2);
		} else {
			sys.io.File.saveContent(templatePath, content);
		}

		// warn('${Emoji.x} ${Type.getClassName(ConvertService)} ${path}');
	}
}
