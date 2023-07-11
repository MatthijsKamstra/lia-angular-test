package;

import AST.BasicObject;
import AST.NgIfObject;
import AST.InputObj;
import AST.ComponentObject;
import AST.FuncObj;
import utils.RegEx;
import AST.HTMLClassObject;
import haxe.Json;

class ExtractHTML {
	public static final OBJ_DEFAULT:HTMLClassObject = {
		name: '',
		fileName: '',
		type: '',
		className: '',
		_content: '',
		dataTestID: '',
		hasDataTestID: false,
		isFinished: false,
		components: [],
		interpolations: [],
		inputs: [],
		outputs: [],
		ngif: []
	};
	public static var OBJ:HTMLClassObject;

	/**
	 * extract data from file
	 *
	 * @param content	content of the file (probably without comments)
	 * @param name		name of the class/name of the file (example: `Foobar` or `Barfoo`)
	 * @param type		type of class (example: `Service` or `Component`)
	 */
	public static function runExtract(content:String, name:String, type:String = 'html') {
		// restart OBJ every time it runs
		OBJ = Json.parse(Json.stringify(OBJ_DEFAULT));

		// create filename/class name
		var fileName = '${Strings.toUpperCamel(name)}${type}';

		OBJ.fileName = name;
		OBJ.name = 'app-' + name.replace('.component.html', '');
		OBJ.className = '${Strings.toUpperCamel(OBJ.name.replace('app-', ''))}Component';
		OBJ.type = OBJ.className;
		OBJ.dataTestID = OBJ.name;
		OBJ.hasDataTestID = content.indexOf('data-testid="${OBJ.name}"') != -1;
		OBJ._content = content;

		// -----------------------------------------------------------------
		// Find angular components : `<app-foobar [t]='xx' ></app-foobar>`
		// -----------------------------------------------------------------
		// `<app-icons icon="{{getIcon()}}"></app-icons>`
		var matches = RegEx.getMatches(RegEx.htmlAngularComponent, content);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// log(match);

				var _name = match.split(' ')[0].replace('<', ''); // app-foobar
				var _cleanName = _name.replace('app-', ''); // foobar

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
							_content: _value.replace('\n', ''),
						}
						_functionsArr.push(_funcObj);
					}
				}

				//
				var _inputArr:Array<InputObj> = [];
				var _inputMatchArr = match.replace('<', '').replace('>', '').split(' ');
				for (j in 0..._inputMatchArr.length) {
					// trace(_inputMatchArr[j]);
					var _input = _inputMatchArr[j].split('=')[0];
					var _input2 = _inputMatchArr[j].split('=')[1];
					// trace(_input);
					// trace(_input2);
					if (_input.indexOf('data-testid') != -1) {
						// that is the only one we don't need to test
						continue;
					}
					var __input:InputObj = {
						name: _input.replace('[', '').replace(']', ''),
						_test: _input2,
					};
					if (_input2 != null)
						_inputArr.push(__input);
				}

				var _hasDataTestID:Bool = match.indexOf('data-testid=') != -1;

				var _componentObj:ComponentObject = {
					name: _name,
					className: '${Strings.toUpperCamel(_cleanName)}Component',
					type: '${Strings.toUpperCamel(_cleanName)}Component',
					_content: match.replace('\n', ''),
					hasDataTestID: _hasDataTestID,
					functions: _functionsArr,
					inputs: _inputArr,
				};

				// trace(_componentObj);
				OBJ.components.push(_componentObj);
			}
		}

		// -----------------------------------------------------------------
		// Find angular *ngIf
		// -----------------------------------------------------------------
		// `<app-icons icon="{{getIcon()}}"></app-icons>`
		var matches = RegEx.getMatches(RegEx.htmlAngularIfElse, content);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var ngIf = matches[i];
				// log(ngIf);

				var _hasDataTestID:Bool = ngIf.indexOf('data-testid=') != -1;

				var __id2 = '';
				if (_hasDataTestID) {
					var __id = ngIf.split('data-testid=')[1];
					__id2 = __id.split(' ')[0].replace("\"", '');
				}

				var _ngif:NgIfObject = {
					_id: __id2,
					hasDataTestID: _hasDataTestID,
					_content: ngIf.replace('\n', '')
				};

				OBJ.ngif.push(_ngif);
			}
		}

		// -----------------------------------------------------------------
		// Find angular {{ xxx }}
		// -----------------------------------------------------------------
		// `<span class="slider {{this.shape}}"></span>`
		var matches = RegEx.getMatches(RegEx.htmlAngularReactive, content.replace('\n', ' '));
		if (matches.length > 0) {
			log(matches);
			for (i in 0...matches.length) {
				var _match = matches[i];
				log(_match);

				var _value = _match.split('{{')[1].split('}}')[0];
				var _valueClean = _value.replace('this.', '');

				var _obj:BasicObject = {
					dataTestID: '${OBJ.name}-${_valueClean}',
					value: _valueClean,
					_value: _value,
					hasDataTestID: _match.indexOf('data-testid=') != -1,
					_content: _match.replace('\n', ''),
				}

				OBJ.interpolations.push(_obj);
			}
		}
		// -----------------------------------------------------------------
		// Find angular ()
		// -----------------------------------------------------------------
		// `<input type="checkbox" [checked]="isChecked" (change)="onChangeHandler(!isChecked)">`
		var matches = RegEx.getMatches(RegEx.htmlAngularOutput, content.replace('\n', ' '));
		if (matches.length > 0) {
			log(matches);
			for (i in 0...matches.length) {
				var _match = matches[i];
				log(_match);
				var _property = _match.split('(')[1].split(')')[0];
				var _propertyClean = _property.replace('this.', '');

				var _value = _match.split(')=')[1].split(' ')[0];
				var _valueClean = _value.replace('"', '').replace('\'', '').replace('>', '');

				var _obj:BasicObject = {
					dataTestID: '${OBJ.name}-${_propertyClean}'.toLowerCase(),
					value: _valueClean.replace('(', '').replace(')', ''),
					_value: _value,
					property: _propertyClean,
					_property: _property,
					hasDataTestID: _match.indexOf('data-testid=') != -1,
					_content: _match.replace('\n', ''),
				}

				if (_value.indexOf('(') != -1) {
					var _funcName = _valueClean.split('(')[0];

					var _param = _valueClean.split('(')[1].replace(')', '');
					var _params = _param.split(',');

					_obj.valueFunction = {
						name: _funcName,
						param: _param,
						params: _params,
					}
				}

				OBJ.outputs.push(_obj);
			}
		}
		// -----------------------------------------------------------------
		// Find angular []
		// -----------------------------------------------------------------
		// `<input type="checkbox" [checked]="isChecked" (change)="onChangeHandler(!isChecked)">	`
		var matches = RegEx.getMatches(RegEx.htmlAngularInput, content.replace('\n', ' '));
		if (matches.length > 0) {
			log(matches);
			for (i in 0...matches.length) {
				var _match = matches[i];
				log(_match);

				var _property = _match.split('[')[1].split(']')[0];
				var _propertyClean = _property.replace('this.', '');

				var _value = _match.split(']=')[1].split(' ')[0];
				var _valueClean = _value.replace('"', '').replace('\'', '');

				var _obj:BasicObject = {
					dataTestID: '${OBJ.name}-${_propertyClean}'.toLowerCase(),
					value: _valueClean.replace('(', '').replace(')', ''),
					_value: _value,
					property: _propertyClean,
					_property: _property,
					hasDataTestID: _match.indexOf('data-testid=') != -1,
					_content: _match.replace('\n', ''),
				}

				if (_value.indexOf('(') != -1) {
					var _funcName = _valueClean.split('(')[0];

					var _param = _valueClean.split('(')[1].replace(')', '');
					var _params = _param.split(',');

					_obj.valueFunction = {
						name: _funcName,
						param: _param,
						params: _params,
					}
				}

				OBJ.inputs.push(_obj);
			}
		}
		// -----------------------------------------------------------------
		// Find angular components
		// -----------------------------------------------------------------

		OBJ.isFinished = true;
		info('end extract');
		// log(OBJ);
	}
}
