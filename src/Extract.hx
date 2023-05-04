package;

import sys.FileSystem;
import haxe.Json;
import utils.RegEx;

class Extract {
	public static var OBJ = {
		'constructor': {
			'params': []
		},
		'imports': []
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
		var obj = {
			'constructor': {
				'params': [{"name": 'test', 'type': 'foo'}]
			}
		};
		obj.constructor.params.pop(); // remove example
		for (i in 0...constructorParamArr.length) {
			var _con = constructorParamArr[i].trim();
			// trace(_con);
			if (_con == '')
				continue;
			var _name = _con.split(':')[0].trim();
			var _type = _con.split(':')[1].trim();
			obj.constructor.params.push({
				name: _name,
				type: _type
			});
		}
		// log(obj);

		OBJ.constructor = obj.constructor;
		log(OBJ);

		// -----------------------------------------------------------------
		// Find functions
		// -----------------------------------------------------------------
		// TODO: this is probably a bad idea, to use `\n\n` to split files into an array
		var arr = cleandedStr.split('\n\n');
		// log(arr);
		// log(arr.length);

		for (i in 0...arr.length) {
			var _arr = arr[i];
			// trace('${i}: ' + _arr.trim());
			if (_arr.indexOf('):') != -1) {
				log('${i}. looks like a function');
			}
		}
	}
}
