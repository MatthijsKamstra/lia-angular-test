package convert;

import utils.TranslateName;
import AST;
import const.Config;
import haxe.Json;
import remove.RemoveComment;
import spec.SpecComponent;
import utils.Copyright;
import utils.GenValues;
import utils.GeneratedBy;

class ConvertHTML {
	private var OBJ:HTMLClassObject;

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
		ExtractHTML.runExtract(originalContentNoComment, originalFileName.replace('.component.ts', ''), 'Component');
		OBJ = ExtractHTML.OBJ;

		// TODO: need to extract info from template and typesciprt

		// start creating the spec of this file/component
		var ts = new SpecComponent(className, TS_OBJ);
		// add imports
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
		// ts.addFunction('// add functions **');

		var html = new SpecTemplate(className, OBJ);
		html.addOriginal(originalContentNoComment);

		// TypeScript (ts)
		// add data extras
		ts.addFunction('// ----------------- ${OBJ.type} tests html template ----------------\n');

		// -----------------------------------------------------------
		// Create the test for html current page
		// -----------------------------------------------------------
		var name = '${Strings.toUpperCamel(className)}Component';
		mute('use test for html components "${name}"');
		ts.addFunction('describe(\'${name} default html test\', () => {');
		ts.addFunction(createDefaultTest(OBJ, '\t\t'));
		ts.addFunction('});\n');

		// -----------------------------------------------------------
		// use a empty test to work from
		// -----------------------------------------------------------
		var name = '${Strings.toUpperCamel(className)}Component';
		mute('use test for html components "${name}"');
		ts.addFunction('// ${name}');
		ts.addFunction('describe(\'${name} html components\', () => {');
		ts.addFunction('\t// ');
		ts.addFunction(createEmptyTest(name, '\t\t'));
		ts.addFunction('});\n');

		// -----------------------------------------------------------
		// update functions in ts file
		// -----------------------------------------------------------
		// ts.addFunction('// add functions ****');
		if (OBJ.components.length >= 0) {
			var name = '${Strings.toUpperCamel(className)}Component';
			mute('use test for html components "${name}"');
			ts.addFunction('// ${name}');
			ts.addFunction('describe(\'${name} html components\', () => {');
			// ts.addFunction('// OBJ.components.length: ${OBJ.components.length}\n');
			for (i in 0...OBJ.components.length) {
				// ts.addFunction('// ${OBJ.components[i]}');
				var _obj:ComponentObject = OBJ.components[i];
				ts.addFunction('\t// ${_obj.name}');
				ts.addFunction(createComponentTest(_obj, '\t\t'));
			}
			ts.addFunction('});\n');
		}
		// try to fix imports
		if (OBJ.components.length >= 0) {
			for (i in 0...OBJ.components.length) {
				var _obj:ComponentObject = OBJ.components[i];
				ts.addImport('// not sure where the file comes from');
				var _import = '// import { ${Strings.toUpperCamel(_obj.type)} } from \'../${_obj.type.toLowerCase().replace('component', '.component')}\';';
				ts.addImport('${_import}\n');
			}
		}
		ts.addImport('import { By } from \'@angular/platform-browser\';');

		// -----------------------------------------------------------
		// update the imports from ts files
		// -----------------------------------------------------------
		ts.addImport('// import directly from ${className}.component');
		for (i in 0...TS_OBJ.imports.length) {
			var _import = TS_OBJ.imports[i];
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

		// HTML test
		html.addData('<!-- ${Strings.toUpperCamel(className)}Component -->');
		html.addData('<!-- Adjustments to components: -->');
		html.addData('<!--\ndata-testid="app-${className}"\n-->');
		// -----------------------------------------------------------
		// add data to tag for testing in html file
		// -----------------------------------------------------------
		if (OBJ.components.length >= 0) {
			mute('create data into the components');
			for (i in 0...OBJ.components.length) {
				var _comp = OBJ.components[i];
				if (!_comp.hasDataElement) {
					// html.addData('<!-- ${_comp} -->');
					// html.addData('<!-- ${_comp.name} -->');
					// html.addData('<!-- data-testid="${_comp.name}" -->');
					var newContent = _comp._content.replace(_comp.name, '${_comp.name} data-testid="${_comp.name}"');
					html.addData('<!--\n${newContent}\n-->');
				}
			}
		}
		html.addData('<!-- Adjustments for `*ngIf` -->');
		if (OBJ.ngif.length >= 0) {
			mute('create data for test with ngIf');
			for (i in 0...OBJ.ngif.length) {
				var _ngif = OBJ.ngif[i];
				if (!_ngif.hasDataElement) {
					html.addData('<!-- ${OBJ.name} -->');
					// html.addData('<!-- ${_ngif} -->');
					// // html.addData('<!-- ${_ngif._id} -->');
					// // html.addData('<!-- data-testid="${_ngif._id}" -->');
					var newContent = _ngif._content.replace(_ngif._id, '${_ngif._id} data-testid="${_ngif._id}"');
					html.addData('<!--\n${newContent}\n-->');
				}
			}
		}

		warn(OBJ);

		// -----------------------------------------------------------
		// create and save file
		// -----------------------------------------------------------

		// default typescript template
		var contentTS:String = //
			GeneratedBy.message('ts') //
			+ '\n\n' //
			+ Copyright.init('ts') //
			+ '\n\n' //
			+ ts.create() //
			+ '';

		// default HTML template
		var contentHTML:String = //
			GeneratedBy.message('html') //
			+ '\n\n' //
			+ Copyright.init('html') //
			+ '\n\n' //
			+ html.create() //
			+ '';

		// + '/**\n\n${originalContentNoComment}\n\n*/';

		// correct filename
		var htmlPath = '${parent}/${newFileName}';
		var tsPath = '${parent}/${newFileName.replace('_gen_.html', '_gen_.html.speec.ts')}';
		var jsonPath = '${parent}/${newFileName.replace('.html', '.html.json')}';
		var json = Json.stringify(OBJ, null, '  ');

		// log(htmlPath);
		// log(jsonPath);
		// log(tsPath);

		// if (!Config.IS_OVERWRITE) {
		// 	// create a name that is destincable from orignal file
		// 	htmlPath = '${parent}/${newFileName.replace('.spec', '_gen_.speec')}';
		// }

		if (Config.IS_DRYRUN) {
			info('DRYRUN: write ${htmlPath.split('/src')[1]}', 2);
		} else {
			info('Open original file: ${path}', 2);
			info('Open generated test file: ${htmlPath}', 2);
			info('Open generated json file: ${jsonPath}', 2);
			// content = content.replace('\n\n\n', '\n\n');
			// content = content.replace('\n\n', '\n');
			// // content = content.replace('\n\n\n', '\n');
			// contentTS = contentTS.replace('\n\n\n', '\n\n').replace('\n\n', '\n');
			sys.io.File.saveContent(htmlPath, contentHTML);
			sys.io.File.saveContent(tsPath, contentTS);
			sys.io.File.saveContent(jsonPath, json);
		}

		// warn('${Emoji.x} ${Type.getClassName(ConvertService)} ${path}');
	}

	// ____________________________________ tests ____________________________________

	function createDefaultTest(OBJ:HTMLClassObject, ?tabs:String = '\t'):String {
		var title = '#should be create with correct `data-testid=${OBJ.name}`';
		var out = '\n${tabs}';
		out += 'it(\'${title}\', () => {
${tabs}\t// Arrange
${tabs}\tconst _el: HTMLElement = fixture.debugElement.query(By.css(\'[data-testid="${OBJ.name}"]\')).nativeElement;
${tabs}\t// Act
${tabs}\tfixture.detectChanges();
${tabs}\t// Assert
${tabs}\texpect(_el).toBeTruthy();
${tabs}});
';
		return out;
	}

	function createEmptyTest(name:String, ?tabs:String = '\t'):String {
		var title = name;
		var out = '\n${tabs}/*\n${tabs}';
		out += 'it(\'${title}\', () => {
${tabs}\t// Arrange
${tabs}\tconst _el: HTMLElement = fixture.debugElement.query(By.css(\'[data-testid="foo"]\')).nativeElement;
${tabs}\t// Act
${tabs}\tfixture.detectChanges();
${tabs}\t// Assert
${tabs}\texpect(_el).toBeTruthy();
${tabs}});
${tabs}*/;
';
		return out;
	}

	function createComponentTest(compObj:ComponentObject, ?tabs:String = '\t'):String {
		var title = ShouldTitleTest.getShouldComponentTitle(compObj);
		var out = '\n${tabs}';
		out += 'it(\'${title}\', () => {
${tabs}\t${convertComponentObj2Test(compObj, tabs)}
${tabs}});
';
		return out;
	}

	function convertComponentObj2Test(compObj:ComponentObject, ?tabs:String = '\t'):String {
		var out = '// Arrange
${tabs}\tconst _${Strings.toLowerCamel(compObj.type)}: ${compObj.type} = fixture.debugElement.query(By.css(\'[data-testid="${compObj.name}"]\')).nativeElement;
${tabs}\t// Act
${tabs}\tfixture.detectChanges();
${tabs}\t// Assert
${tabs}\texpect(_${Strings.toLowerCamel(compObj.type)}).toBeTruthy();
';
		for (i in 0...compObj.inputs.length) {
			var _compObjInputs:InputObj = compObj.inputs[i];
			trace(_compObjInputs);
			// out += '${tabs}\t// ${_compObjInputs.name}\n';
			out += '${tabs}\texpect(_${Strings.toLowerCamel(compObj.type)}.${_compObjInputs.name}).toBeTruthy();\n';
		}

		// ${tabs}\t// expect(_${Strings.toLowerCamel(compObj.type)}.title).toBeTruthy();
		return out;
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
