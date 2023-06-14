package spec.convert;

import AST.VarObj;

class Var2Value {
	/**
	 * [Description]
	 * @param vars
	 * @return String
	 */
	static public function create(vars:VarObj):String {
		var out = Type2Value.create(vars.type);
		if (vars.value != "") {
			out = vars.value;
		}
		// TODO: not sure how to do FormControl so remove it for now
		if (vars._content.indexOf('FormControl') != -1) {
			out = '';
		}
		return out;
	}
}
