package convert;

import AST;
import const.Config;
import haxe.Json;
import remove.RemoveComment;
import spec.SpecComponent;
import utils.Copyright;
import utils.GenValues;
import utils.GeneratedBy;

class ConvertHTML {
	private var OBJ:TypeScriptClassObject;

	/**
	 * constructor
	 * @param path to original file (at this moment probably a component)
	 */
	public function new(path:String, TS_OBJ:TypeScriptClassObject) {
		// read the content of the file
		var originalContent = sys.io.File.getContent(path);
		var originalContentNoComment = RemoveComment.all(originalContent, 'html');

		// filename
		var originalFileName = Path.withoutDirectory(path);
		var newFileName = originalFileName.replace('.html', '_gen_.html');
		var className = originalFileName.replace('.component.html', '');

		// parent dir
		var parent = Path.directory(path);

		log(originalFileName);
		log(newFileName);
		log(className);

		// // first try for new extract
		// Extract.runExtract(originalContentNoComment, originalFileName.replace('.component.ts', ''), 'Component');
		// OBJ = Extract.OBJ;
		// OBJ = {};

		// TODO: need to extract info from template and typesciprt

		// start creating the spec of this file/component
		var html = new SpecTemplate(className, {});
		// add imports
		// html.addImport('// add imports');
		// // add constructor
		// html.addConstructor('// add constructor');
		// // add providers
		// html.addProviders('/* add providers */');
		// // add testbed
		// html.addTestbed('// testbed');
		// // add values
		// html.addVariable('// add vars');
		// // add functions
		// html.addFunction('// add functions');

		// -----------------------------------------------------------
		// create and save file
		// -----------------------------------------------------------

		// default typescript template
		var content:String = //
			GeneratedBy.message('html') //
			+ '\n\n' //
			+ Copyright.init('html') //
			+ '\n\n' //
			+ originalContent //
			// + html.create() //
			+ '';

		// + '/**\n\n${originalContentNoComment}\n\n*/';

		// correct filename
		var templatePath = '${parent}/${newFileName}';
		var jsonPath = '${parent}/_${newFileName.replace('.spec.ts', '.json')}';
		var json = Json.stringify(OBJ, null, '  ');

		if (!Config.IS_OVERWRITE) {
			// create a name that is destincable from orignal file
			templatePath = '${parent}/${newFileName.replace('.spec', '_gen_.speec')}';
		}

		if (Config.IS_DRYRUN) {
			info('DRYRUN: write ${templatePath.split('/src')[1]}', 2);
		} else {
			info('Open original file: ${path}', 2);
			info('Open generated test file: ${templatePath}', 2);
			info('Open generated json file: ${jsonPath}', 2);
			// content = content.replace('\n\n\n', '\n\n');
			// content = content.replace('\n\n', '\n');
			// // content = content.replace('\n\n\n', '\n');
			// // content = content.replace('\n\n\n', '\n\n').replace('\n\n', '\n');
			sys.io.File.saveContent(templatePath, content);
			// sys.io.File.saveContent(jsonPath, json);
		}

		// warn('${Emoji.x} ${Type.getClassName(ConvertService)} ${path}');
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
