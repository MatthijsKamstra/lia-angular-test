package convert;

import AST.VarObj;
import AST.FuncObj;

class ShouldTitleTest {
	static public function getTitle(obj:FuncObj) {
		return '#${obj.name} should return ${obj.returnValue._content}';
	}

	static public function getShouldVarsTitle(func:FuncObj, vars:VarObj) {
		return '#should set ${vars.name} with ${vars.type} value';
	}
}
