package;

import sys.FileSystem;
import haxe.Json;
import utils.RegEx;

class Extract {
	public static var OBJ = {
		constructor: {
			params: []
		},
		imports: [],
		functions: []
	};

	public static var importMap:Map<String, String> = [];

	public static function runExtract(content:String, name:String) {
		// log(content);

		var fileName = '${Strings.toUpperCamel(name)}Service';

		var str = content.split(fileName)[1].trim();

		var strStart = (str.indexOf('{'));
		var strEnd = (str.lastIndexOf('}'));
		var cleandedStr = str.substring(strStart + 1, strEnd).replace('\n\t', '\n').trim();
		// log(cleandedStr);

		// -----------------------------------------------------------------
		// Find imports
		// -----------------------------------------------------------------

		var matches = RegEx.getMatches(RegEx.classImports, content);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// trace(match);
				OBJ.imports.push(match);

				var startNr = match.indexOf('{');
				var endNr = match.indexOf('}');

				//  TODO: what to do with `import { One, Two} from ....`
				var name = match.substring(startNr + 1, endNr).trim();
				// warn(name);
				importMap.set('${name}', match);
			}
		}
		log(OBJ);
		info('importMap: ' + importMap);

		// -----------------------------------------------------------------
		// Find constructor
		// -----------------------------------------------------------------

		// log('"constructor(" :: ' + str.indexOf('constructor('));
		// log('") { }" :: ' + str.indexOf(') { }'));

		var matches = RegEx.getMatches(RegEx.classConstructor, str);
		var constructorParamString = (matches[0]) //
			.replace('constructor', '') // remove 'constructor' word
			.replace('(', '') // remove '('
			.replace('private', '') // FIXME remove 'private' (not sure, might need this in the future)
			.replace('public', '') // FIXME remove 'public' (not sure, might need this in the future)
			.replace('\t', '') // remove tab
			.replace('\n', ''); // remove enter/return
		// log(constructorParamString);
		var constructorParamArr = constructorParamString.split(',');
		// log(constructorParamArr);

		// private|public
		// param name
		// param type
		var constrObj = {
			constructor: {
				params: [
					{
						name: 'test',
						type: 'foo'
					}
				]
			}
		};
		constrObj.constructor.params.pop(); // remove example
		for (i in 0...constructorParamArr.length) {
			var _con = constructorParamArr[i].trim();
			// trace(_con);
			if (_con == '')
				continue;

			var _obj:ParamObj = convertParams(_con);

			constrObj.constructor.params.push(_obj);
		}
		// log(obj);

		OBJ.constructor = constrObj.constructor;
		log(OBJ);

		// -----------------------------------------------------------------
		// Find functions
		// -----------------------------------------------------------------
		// TODO: this is probably a bad idea, to use `\n\n` to split files into an array
		var arr = cleandedStr.split('\n\n');
		// log(arr);
		// log(arr.length);

		// try to check with regex
		var matches = RegEx.getMatches(RegEx.classFunction, cleandedStr);
		warn('is this the value simular to the other value');
		warn('split: ${arr.length} (with constructor) vs regex: ${matches.length}');

		// setting up object
		var funcObj = {
			functions: [
				{
					name: '',
					params: [
						{
							name: 'test',
							type: 'foo'
						}
					],
					returnValue: '',
					string: ''
				}
			]
		};
		funcObj.functions.pop(); // remove example

		for (i in 0...arr.length) {
			var _str = arr[i];
			// trace('${i}: ' + _str.trim());
			if (_str.indexOf('):') != -1) {
				info('${i}. looks like a function');

				// get function name
				var _name = _str.split('(')[0].trim();

				// get return value
				var _return = _str.split(':')[1].split('{')[0].trim();

				// get params (name and type)
				var _paramArr = getParamsFromString(_str);

				var _funcObj = {
					name: _name,
					returnValue: _return,
					params: _paramArr,
					string: _str
				}
				OBJ.functions.push(_funcObj);
			}
		}

		log(OBJ);
	}

	// ____________________________________ tools ____________________________________

	static function getParamsFromString(val:String):Array<ParamObj> {
		var arr = [];
		var startIndex = val.indexOf('(');
		var endIndex = val.indexOf(')');
		var paramString = val.substring(startIndex + 1, endIndex);
		// warn(paramString);
		// warn(val);
		var _paramArr = paramString.split(',');
		for (i in 0..._paramArr.length) {
			var _param = _paramArr[i].trim();
			if (_param == '')
				continue;
			if (val.indexOf(':') != -1) {
				var _obj:ParamObj = convertParams(_param);
				arr.push(_obj);
			}
		}
		return arr;
	}

	static function convertParams(val:String):ParamObj {
		var _name = val.split(':')[0].trim();
		var _type = val.split(':')[1].trim();
		return {
			name: _name,
			type: _type
		}
	}
}

typedef ParamObj = {
	@:optional var _id:String;
	@:optional var access:String;
	var name:String;
	var type:String;
}
