package convert;

import AST.VarObj;
import AST.FuncObj;

class ShouldTitleTest {
	static public function getTitle(func:FuncObj) {
		return '#${func.name} should return ${func.returnValue._content}';
	}

	public static function getSubTitle(func:FuncObj) {
		return '#should return ${func.returnValue._content}';
	}

	static public function getShouldVarsTitle(vars:VarObj) {
		return '#should set "${vars.name}" with `${vars.type}` value';
	}
}
