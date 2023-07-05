package;

import AST.InputObj;
import AST.ComponentObject;
import AST.FuncObj;
import utils.RegEx;
import AST.HTMLClassObject;
import haxe.Json;

class ExtractHTML {
	public static final OBJ_DEFAULT:HTMLClassObject = {
		isFinished: false,
		components: []
	};
	public static var OBJ:HTMLClassObject = {
		isFinished: false,
		components: []
	};

	/**
	 * extract data from file
	 *
	 * @param content	content of the file (probably without comments)
	 * @param name		name of the class/name of the file (example: `Foobar` or `Barfoo`)
	 * @param type		type of class (example: `Service` or `Component`)
	 */
	public static function runExtract(content:String, name:String, type:String = 'Service') {
		// restart OBJ every time it runs
		OBJ = Json.parse(Json.stringify(OBJ_DEFAULT));

		// create filename/class name
		var fileName = '${Strings.toUpperCamel(name)}${type}';

		// -----------------------------------------------------------------
		// Find angular components
		// -----------------------------------------------------------------
		// `<app-icons icon="{{getIcon()}}"></app-icons>`
		var matches = RegEx.getMatches(RegEx.htmlAngularComponent, content);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// log(match);

				var _name = match.split(' ')[0].replace('<', '');
				var _cleanName = _name.replace('app-', '');

				// get functions within component
				var _functionsArr:Array<FuncObj> = [];
				var interpolationArr = RegEx.getMatches(RegEx.htmlInterpolation, match);
				if (interpolationArr.length > 0) {
					// log(interpolationArr);
					for (i in 0...interpolationArr.length) {
						// log(interpolationArr[i]);
						var _value = interpolationArr[i];
						var _funcObj:FuncObj = {
							access: '',
							name: '',
							returnValue: {
								value: '',
								type: '',
								_content: '',
							},
							params: [],
							_content: _value,
						}
						_functionsArr.push(_funcObj);
					}
				}

				//
				var _inputArr:Array<InputObj> = [];
				var _inputMatchArr = match.replace('<', '').replace('>', '').split(' ');
				for (j in 0..._inputMatchArr.length) {
					trace(_inputMatchArr[j]);
					var _input = _inputMatchArr[j].split('=')[0];
					var _input2 = _inputMatchArr[j].split('=')[1];
					trace(_input);
					trace(_input2);
					if (_input.indexOf('data-testid') != -1) {
						// that is the only one we don't need to test
						continue;
					}
					var __input:InputObj = {
						name: _input,
						_test: _input2,
					};
					if (_input2 != null)
						_inputArr.push(__input);
				}

				var _hasDataElement:Bool = match.indexOf('data-testid=') != -1;

				var _componentObj:ComponentObject = {
					name: _name,
					className: '${Strings.toUpperCamel(_cleanName)}Component',
					type: '${Strings.toUpperCamel(_cleanName)}Component',
					_content: match,
					hasDataElement: _hasDataElement,
					functions: _functionsArr,
					inputs: _inputArr,
				};

				trace(_componentObj);
				OBJ.components.push(_componentObj);
			}
		}

		// -----------------------------------------------------------------
		// Find angular components
		// -----------------------------------------------------------------

		// -----------------------------------------------------------------
		// Find angular components
		// -----------------------------------------------------------------

		OBJ.isFinished = true;
		info('end extract');
		// log(OBJ);
	}
}
