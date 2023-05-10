package;

import sys.FileSystem;
import haxe.Json;
import utils.RegEx;
import AST;

class Extract {
	public static final OBJ_DEFAULT = {
		hasHttpClient: false,
		hasUrl: false,
		URL: '',
		constructor: {
			params: []
		},
		imports: [],
		functions: []
	};

	public static var OBJ = {
		hasHttpClient: false,
		hasUrl: false,
		URL: '',
		constructor: {
			params: []
		},
		imports: [],
		functions: []
	};

	// public static var importMap:Map<String, String> = [];

	public static function runExtract(content:String, name:String) {
		// log(content);

		// restart OBJ every time it runs
		OBJ = Json.parse(Json.stringify(OBJ_DEFAULT));

		// create filename/class name
		var fileName = '${Strings.toUpperCamel(name)}Service';

		// get the content of the class values
		var startIndex = content.indexOf(fileName);
		// trace(startIndex);
		var str = content.substring(startIndex).trim();
		var strStart = (str.indexOf('{'));
		var strEnd = (str.lastIndexOf('}'));
		var cleandedStr = str.substring(strStart + 1, strEnd).replace('\n\t', '\n').trim();
		// trace(content);
		// trace(str);
		// trace(cleandedStr);

		// bools
		OBJ.hasHttpClient = (str.indexOf('HttpClient') != -1);
		OBJ.hasUrl = (str.toLowerCase().indexOf('url') != -1); // guessing at best :(

		// URL
		var matches = RegEx.getMatches(RegEx.hasURL, cleandedStr);
		OBJ.URL = matches[0]; // ugghhhhh, fix later

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

				var startIndex = match.indexOf('{');
				var endIndex = match.indexOf('}');

				//  TODO: what to do with `import { One, Two} from ....`
				var name = match.substring(startIndex + 1, endIndex).trim();
				// warn(name);
				// importMap.set('${name}', match);
			}
			// log(OBJ);
			// info('importMap: ' + importMap);
		}

		// -----------------------------------------------------------------
		// Find constructor
		// -----------------------------------------------------------------
		var matches = RegEx.getMatches(RegEx.classConstructor, str);
		// not all classes have a constructor, check for it
		if (matches.length > 0) {
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

				var _obj:TypedObj = convertParams(_con);

				constrObj.constructor.params.push(_obj);
			}
			// log(obj);

			OBJ.constructor = constrObj.constructor;
			// log(OBJ);
		}

		// -----------------------------------------------------------------
		// Find functions
		// -----------------------------------------------------------------
		// TODO: this is probably a bad idea, to use `\n\n` to split files into an array
		var arr = cleandedStr.split('\n\n');
		// trace(arr);
		// trace(arr.length);

		// try to check with regex
		var matches = RegEx.getMatches(RegEx.classFunction, cleandedStr);
		warn('is this the value similar to the other value');
		warn('split: ${arr.length} (with constructor and vars) vs regex: ${matches.length}');

		for (i in 0...arr.length) {
			var _str = arr[i];
			// trace('${i}: ' + _str.trim());
			if (_str.indexOf('):') != -1) {
				// info('${i}. looks like a function');

				// private|public
				var _access = (_str.indexOf('private') != -1) ? 'private' : 'public';

				// get function name
				var _name = _str.replace('public', '').replace('public', '').split('(')[0].trim();

				// get return value
				var _return = _str.split('):')[1].split('{')[0].trim();

				// warn(_str);
				// warn(_return);

				// get params (name and type)
				var _paramArr = getParamsFromString(_str);

				// URL
				var matches = RegEx.getMatches(RegEx.hasURL, _str);
				var _URL = ''; // ugghhhhh, fix later
				if (matches[0] != null)
					_URL = matches[0]; // ugghhhhh, fix later

				var _requestType = 'GET';

				// TODO: probably better to use the constructor.param[x].type == HttpClient
				// but not available at this point
				// assume `http : HttpClient`
				if (_str.indexOf('http.get') != -1) {
					_requestType = 'GET';
				}
				if (_str.indexOf('http.post') != -1) {
					_requestType = 'POST';
				}

				var _funcObj:FuncObj = {
					URL: _URL,
					requestType: _requestType,
					access: _access,
					name: _name,
					returnValue: getReturnValues(_return),
					params: _paramArr,
					_content: _str,
				}
				OBJ.functions.push(_funcObj);

				// trace(_funcObj);
			}
		}

		info('end extract');
		// log(OBJ);
	}

	/**
	 * extract `: Observable<IHelp>` into `Observable` and `IHelp`
	 * extract `: Foobar` into `Foobar`
	 * extract `: Foobar | string` into `Foobar` and `string`
	 * extract `: Foobar[]` into `Foobar` and `[]`
	 *
	 * @param val
	 */
	static function getReturnValues(val:String):TypedObj {
		// warn(val);

		var _value = '';
		var _type = 'void'; // use void when no return type is created
		if (val.indexOf('<') != -1) {
			_value = val.split('<')[1].split('>')[0].trim();
			_type = val.split('<')[0].trim();
		}
		if (val.indexOf('|') != -1) {
			_value = val.split('|')[1].trim();
			_type = val.split('|')[0].trim();
		}
		if (_value == '') {
			_type = val.trim();
		}
		return {
			value: _value,
			type: _type,
			access: '', // private|public|none
			_content: val,
		};
	}

	// ____________________________________ tools ____________________________________

	static function getParamsFromString(val:String):Array<TypedObj> {
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
				var _obj:TypedObj = convertParams(_param);
				arr.push(_obj);
			}
		}
		return arr;
	}

	/**
	 * @example
	 * 		sortedData: ISortedData
	 * 		public sortedData: ISortedData
	 *
	 * @param val
	 * @return TypedObj
	 */
	static function convertParams(val:String):TypedObj {
		// log(val);
		var _access = (val.indexOf('private') != -1) ? 'private' : 'public';
		var _name = val.split(':')[0].trim();
		var _type = val.split(':')[1].trim();
		return {
			access: _access,
			name: _name,
			value: _name,
			type: _type,
			_content: val
		}
	}
}
