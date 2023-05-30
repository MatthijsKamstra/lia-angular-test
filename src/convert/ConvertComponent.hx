package convert;

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
		var OBJ:TypeScriptClassObject = Extract.OBJ;

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
			if (_constructor.type.indexOf('HttpClient') != -1)
				continue;
			ts.addConstructor('\tlet ${_constructor.name}Spy: jasmine.SpyObj<${_constructor.type}>;');
			ts.addTestbed('\t\t${_constructor.name}Spy = TestBed.inject(${_constructor.type}) as jasmine.SpyObj<${_constructor.type}>;');
			ts.addProviders('${_constructor.type}');

			// as jasmine.SpyObj<GroupsService>;
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
				ts.addFunction(createEmptyOnInit(_func, '\t'));
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
					mute('use test with return value "${_func.returnValue.type}"');
					ts.addFunction('describe(\'${_func.name}\', () => {');
					ts.addFunction(createOnInitTest(_func, '\t\t'));

					// ts.addFunction('// OBJ.vars.length: ${OBJ.vars.length}\n');
					for (i in 0...OBJ.vars.length) {
						var _varObj:VarObj = OBJ.vars[i];
						// ts.addFunction('\t// ${_varObj.name}');
						ts.addFunction(createVarsTest(_func, _varObj, '\t\t'));
					}

					ts.addFunction('});\n');
				} else {
					mute('use test with return value "${_func.returnValue.type}"');

					ts.addFunction('describe(\'${_func.name}\', () => {');
					ts.addFunction(createBasicTest(_func, '\t\t'));
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
			// content = content.replace('\n\n', '\n');
			// content = content.replace('\n\n\n', '\n');
			// content = content.replace('\n\n\n', '\n\n');
			// content = content.replace('\n\n\n', '\n\n').replace('\n\n', '\n');
			sys.io.File.saveContent(templatePath, content);
			sys.io.File.saveContent(jsonPath, json);
		}

		// warn('${Emoji.x} ${Type.getClassName(ConvertService)} ${path}');
		// log(json);
	}

	// ____________________________________ create test based upon return type ____________________________________

	function createOnInitTest(func:FuncObj, ?tabs:String = '\t'):String {
		// warn('subscribes total: ' + (func._content.split('.subscribe').length - 1));
		// warn('this total: ' + (func._content.split('this.').length - 1));

		// var matches = RegEx.getMatches(RegEx.getVars, func._content);
		// if (matches.length > 0) {
		// 	// log(matches);
		// 	for (i in 0...matches.length) {
		// 		var match = matches[i];
		// 		trace(match);
		// 	}
		// }

		var out = '\n';
		out += '${tabs}// Test with return type `${func.returnValue.type}`\n${tabs}';
		// out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
		out += 'it(\'${getTitle(func)}\', () => {
${tabs}\tcomponent.ngOnInit();
${tabs}\texpect(component).toBeDefined();
${tabs}});
';

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

	function createEmptyOnInit(func:FuncObj, ?tabs:String = '\t'):String {
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
	function createVarsTest(func:FuncObj, vars:VarObj, ?tabs:String = '\t'):String {
		var title = ShouldTitleTest.getShouldVarsTitle(func, vars);
		var out = '';

		// out += '// this looks like an emtpy ngOnInit\n${tabs}';
		// out += '// Basic test with return type `${func.returnValue.type}`\n${tabs}';
		// out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
		// out += '/**\n${tabs}';
		// log(func);

		out += '\t';
		out += 'it(\'${title}\', () => {
${tabs}\t${setupVars(func, vars, tabs)}
${tabs}});
';
		// out += '${tabs}*/';
		return out;
	}

	// ____________________________________ use vars ____________________________________

	function setupVars(func:FuncObj, vars:VarObj, ?tabs:String = '\t') {
		var out = '// Arrange
${tabs}\tconst _${vars.name}: ${vars.type} = ${convertVar2Value(vars)};
${tabs}\tconst _initial${Strings.toUpperCamel(vars.name)}: ${vars.type} = component.${vars.name};
${tabs}\tcomponent.${vars.name} = _${vars.name};
${tabs}\t// Act
${tabs}\tcomponent.ngOnInit();
${tabs}\t// Assert
${tabs}\texpect(_initial${Strings.toUpperCamel(vars.name)}).toBeUndefined();
${tabs}\texpect(component.${vars.name}).toBe(_${vars.name});';
		return out;
	}

	// ____________________________________ converters ____________________________________

	function convertVar2Value(vars:VarObj):String {
		var out = '';
		switch (vars.type) {
			case 'string':
				out = '"${GenValues.string()}"';
			case 'bool', 'boolean':
				out = 'true';
			case 'any':
				out = '{}';
			default:
				trace("case '" + vars + "': trace ('" + vars + "');");
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
}