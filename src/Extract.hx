package;

import AST;
import haxe.Json;
import sys.FileSystem;
import utils.RegEx;

class Extract {
	public static final OBJ_DEFAULT:TypeScriptClassObject = {
		isFinished: false,
		hasHttpClient: false,
		hasConstructor: false,
		hasOnInit: false,
		hasOnChanged: false,
		hasUrl: false,
		URL: '',
		constructor: {
			params: []
		},
		imports: [],
		functions: [],
		vars: [],
		subscribes: [],
	};

	public static var OBJ:TypeScriptClassObject = {
		isFinished: false,
		hasHttpClient: false,
		hasConstructor: false,
		hasOnInit: false,
		hasOnChanged: false,
		hasUrl: false,
		URL: '',
		constructor: {
			params: []
		},
		imports: [],
		functions: [],
		vars: [],
		subscribes: [],
	};

	// public static var importMap:Map<String, String> = [];

	/**
	 * extract data from file
	 *
	 * @param content	content of the file (probably without comments)
	 * @param name		name of the class/name of the file (example: `Foobar` or `Barfoo`)
	 * @param type		type of class (example: `Service` or `Component`)
	 */
	public static function runExtract(content:String, name:String, type:String = 'Service') {
		// log(content);

		// restart OBJ every time it runs
		OBJ = Json.parse(Json.stringify(OBJ_DEFAULT));

		// create filename/class name
		var fileName = '${Strings.toUpperCamel(name)}${type}';

		// get the content of the class values
		var startIndex = content.indexOf(fileName);

		var str = content.substring(startIndex).trim();
		var strStart = (str.indexOf('{'));
		var strEnd = (str.lastIndexOf('}'));
		var cleandedStr = str.substring(strStart + 1, strEnd).replace('\n\t', '\n').trim();
		// trace(content);
		// trace(str);
		// trace(cleandedStr);

		// bools
		OBJ.hasHttpClient = (str.indexOf('HttpClient') != -1);
		OBJ.hasConstructor = (str.indexOf('constructor') != -1);
		OBJ.hasOnChanged = (str.indexOf('ngOnChanges') != -1);
		OBJ.hasOnInit = (str.indexOf('ngOnInit') != -1);
		OBJ.hasUrl = (str.toLowerCase().indexOf('url') != -1); // guessing at best :(

		Constants.HAS_HTTP_CLIENT = OBJ.hasHttpClient;
		Constants.HAS_CONSTRUCTOR = OBJ.hasConstructor;
		Constants.HAS_ONCHANGED = OBJ.hasOnChanged;
		Constants.HAS_ONINIT = OBJ.hasOnInit;
		Constants.HAS_URL = OBJ.hasUrl;

		if (!OBJ.hasConstructor) {
			warn('This generator doesn\'t work without constructor');
			OBJ.isFinished = false;
			Constants.HAS_FINISHED = OBJ.isFinished;
			return;
		}

		// URL
		var matches = RegEx.getMatches(RegEx.hasURL, cleandedStr);
		// warn(matches);
		OBJ.URL = matches[0]; // ugghhhhh, fix later, much much later!!! (or never!)

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
		// Find .subscribe
		// -----------------------------------------------------------------
		var matches = RegEx.getMatches(RegEx.getSubscribe, content);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// trace(match);
				// OBJ.subscribes.push(match);
				var _obj:SubScribeObj = convertSubScribes(match);
				OBJ.subscribes.push(_obj);
			}
		}

		// -----------------------------------------------------------------
		// get vars
		// -----------------------------------------------------------------
		var temp = cleandedStr.split('constructor')[0];
		var tempArr = temp.split('\n');
		for (i in 0...tempArr.length) {
			var _var = tempArr[i].trim();
			if (_var != '') {
				// warn(v);
				var _obj:VarObj = convertVars(_var);
				OBJ.vars.push(_obj);
			}
		}

		// -----------------------------------------------------------------
		// Find constructor
		// -----------------------------------------------------------------
		if (str.indexOf('constructor') == -1) {
			warn('"is there constructor? " ${str.indexOf('constructor') != -1}');
			warn('this code works only with an constructor');
			warn('add `constructor() { }` between vars and functions');
			return;
		}

		var matches = RegEx.getMatches(RegEx.classConstructor, str);
		// not all classes have a constructor, check for it
		if (matches.length > 0) {
			var constructorParamString = (matches[0]) //
				.replace('constructor', '') // remove 'constructor' word
				.replace('(', '') // remove '('
				.replace('private', '') // FIXME remove 'private' (not sure, might need this in the future)
				.replace('public', '') // FIXME remove 'public' (not sure, might need this in the future)
				.replace('protected', '') // FIXME remove 'protected' (not sure, might need this in the future)
				.replace('\t', '') // remove tab
				.replace('\n', ''); // remove enter/return
			// log(constructorParamString);
			var constructorParamArr = constructorParamString.split(',');
			// log(constructorParamArr);

			// private|public|protected
			// param name
			// param type
			// var constrObj = {
			// 	constructor: {
			// 		params: [
			// 			{
			// 				name: 'test',
			// 				type: 'foo'
			// 			}
			// 		]
			// 	}
			// };
			// constrObj.constructor.params.pop(); // remove example
			for (i in 0...constructorParamArr.length) {
				var _con = constructorParamArr[i].trim();
				// trace(_con);
				if (_con == '')
					continue;

				var _obj:TypedObj = convertParams(_con);

				// constrObj.constructor.params.push(_obj);

				OBJ.constructor.params.push(_obj);
			}
			// log(obj);

			// OBJ.constructor = constrObj.constructor;
			// log(OBJ);
		}

		// -----------------------------------------------------------------
		// Find functions
		// -----------------------------------------------------------------
		// TODO: this is probably a bad idea, to use `\n\n` to split files into an array

		var enter_n = cleandedStr.split('\n');
		var enter_r = cleandedStr.split('\r');

		// warn('enter_n.length: ' + enter_n.length);
		// warn('enter_r.length: ' + enter_r.length);

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

			// ignore contstructor for now
			if (_str.indexOf('constructor') != -1)
				continue;

			// ignore if for now
			if (_str.indexOf('if (') != -1)
				continue;

			// ignore switch for now
			if (_str.indexOf('switch (') != -1)
				continue;

			// ignore switch for now
			if (_str.indexOf('for (') != -1)
				continue;

			if (_str.indexOf(') {') != -1) {
				// trace('might be a function without a return type or void');
			}
			if (_str.indexOf('):') != -1 || _str.indexOf(') {') != -1) {
				// info('${i}. looks like a function');

				// private|public
				var _access = (_str.indexOf('private') != -1) ? 'private' : 'public';

				// get function name
				var _name = _str.replace('public', '').replace('private', '').split('(')[0].trim();

				// get return value
				// check for sort return type
				var _return = 'void';
				if (_str.indexOf('):') != -1) {
					_return = _str.split('):')[1].split('{')[0].trim();
				}

				// warn(_str);
				// warn(_return);

				// get params (name and type)
				var _paramArr = getParamsFromString(_str);

				// URL
				var matches = RegEx.getMatches(RegEx.hasURL, _str);
				var _URL = ''; // ugghhhhh, fix later
				// warn(matches);
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
				if (_str.indexOf('http.delete') != -1) {
					_requestType = 'DELETE';
				}

				var _funcObj:FuncObj = {
					access: _access,
					name: _name,
					returnValue: getReturnValues(_return),
					params: _paramArr,
					_content: _str,
					_guessing: {
						URL: _URL,
						requestType: _requestType,
					}
				}
				OBJ.functions.push(_funcObj);

				// trace(_funcObj);
			}
		}

		OBJ.isFinished = true;
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
		// warn('getReturnValues: ' + val);

		var _value = '';
		var _type = 'void'; // use void when no return type is created
		if (val.indexOf('<') != -1) {
			_value = val.split('<')[1].split('>')[0].trim();
			_type = val.split('<')[0].trim();
		}
		// TODO: what to do with or types????
		// if (val.indexOf('|') != -1) {
		// 	_value = val.split('|')[1].trim();
		// 	_type = val.split('|')[0].trim();
		// }

		// make sure that return type '' is void
		if (_value == '') {
			_type = (val.trim() == '') ? 'void' : val.trim();
		}
		return {
			name: '_${_type.toLowerCase()}', // to make sure we can use it when generating test... but not correclty in use
			value: _value,
			type: _type,
			access: 'none', // protected|private|public|none
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
		var _name = '';
		var _type = '';
		var _access = '';
		_access = (val.indexOf('private') != -1) ? 'private' : 'public';
		_access = (val.indexOf('protected') != -1) ? 'protected' : 'public';
		if (val.indexOf(':') != -1) {
			_name = val.split(':')[0].trim();
			_type = val.split(':')[1].trim();
		}
		return {
			access: _access,
			name: _name,
			value: _name,
			type: _type,
			_content: val
		}
	}

	// this.configSettingsService.getData().subscribe
	// this.helpService.getData().subscribe
	static function convertSubScribes(match:String):SubScribeObj {
		var _val = match;
		var _name = '';
		var _func = '';
		var _value = '';
		var _param = '';
		_val = _val.replace('this.', '').replace('.subscribe', '').replace('()', '');
		_name = _val.split('.')[0];
		_func = _val.split('.')[1];
		return {
			name: _name,
			call: {
				name: _func,
				param: _param,
			},
			_content: match,
		}
	}

	static function convertVars(val:String):VarObj {
		var _val = val;
		var _name = '';
		var _value = '';
		var _type = '';
		var _optional = false;
		var _non_null = false;
		var _decorators:DecoratorsObj = {};

		if (val.indexOf('?') != -1) {
			_optional = true;
			_val = _val.replace('?', '').trim();
		}
		if (val.indexOf('!') != -1) {
			_non_null = true;
			_val = _val.replace('!', '').trim();
		}
		if (val.indexOf('@Input()') != -1) {
			_decorators.input = true;
			_val = _val.replace('@Input()', '').trim();
		}
		if (val.indexOf('@Output()') != -1) {
			_decorators.output = true;
			_val = _val.replace('@Output()', '').trim();
		}

		// warn(_val, 1, 'yellow');

		// @Input() onCancel!: () => void;",
		if (_val.indexOf('() => void') != -1) {
			_value = '() => {}';
			_type = 'any';
			_val = _val.replace(': () => void', '').trim();
		}
		// warn(_val, 2, 'yellow');
		if (_val.indexOf('=') != -1) {
			_value = val.split('=')[1].replace(';', '').trim();
			_val = _val.split('=')[0].trim();
		}
		// removing `;`
		_val = _val.replace(';', '').trim();

		if (_val.indexOf(':') != -1) {
			_name = _val.split(':')[0].trim();
			_type = _val.split(':')[1].trim();
		} else {
			// warn(val);
			if (_name == '')
				_name = _val.split('=')[0].trim();
			if (_type == '')
				_type = 'any'; // hacky
		}

		return {
			name: _name,
			type: _type,
			decorators: _decorators,
			optional: _optional,
			nonnull: _non_null,
			value: _value,
			_content: val,
			// @:optional var _guessing:GuessingObj;
		}
	}
}
