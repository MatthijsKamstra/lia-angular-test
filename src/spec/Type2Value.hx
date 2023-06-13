package spec;

import AST.VarObj;
import AST.FuncObj;
import utils.GenValues;

class Type2Value {
	// static public function create() {
	// 	// var app = new FuncParams2Value();
	// }
	static public function components() {
		// var app = new FuncParams2Value();
	}

	static public function services() {
		// var app = new FuncParams2Value();
	}

	static public function convertFuncReturn2Value(func:FuncObj) {
		return Type2Value.convertType2Value(func.returnValue.type);
	}

	static public function convertFuncParams2Value(func:FuncObj) {
		return Type2Value.convertType2Value(func.params[0].type);
	}

	static public function convertVar2Value(vars:VarObj):String {
		var out = convertType2Value(vars.type);
		if (vars.value != "") {
			out = vars.value;
		}
		// TODO: not sure how to do FormControl so remove it for now
		if (vars._content.indexOf('FormControl') != -1) {
			out = '';
		}
		return out;
	}

	static public function convertType2Value(type:String):String {
		var out = '';
		switch (type) {
			case 'string':
				out = '"${GenValues.string()}"';
			case 'string[]':
				out = '["${GenValues.string()}", "${GenValues.string()}"]';
			case 'bool', 'boolean':
				out = 'true';
			case 'number', 'float':
				out = '5000';
			case 'date', 'Date', 'string | Date':
				out = 'new Date()';
			case 'any':
				out = '{}';
			case 'Function', 'function':
				out = '() => {}';
			case 'undefined':
				out = 'undefined';
			case 'null':
				out = 'null';
			default:
				// SPEC_CONST.getValue(IHELP)
				out = '{} /* SPEC_CONST.getValue(${type.toUpperCase()}) */';
				trace("case '" + type + "': trace ('" + type + "');");
		}
		return out;
	}

	/**
	 * [Description]
	 * @param type
	 * @return String
	 */
	static public function create(type:String):String {
		return Type2Value.convertType2Value(type);
	}
}
