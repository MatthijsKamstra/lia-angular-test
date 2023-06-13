package spec;

import AST.VarObj;

class VarsTest {
	/**
	 * [Description]
	 * @param vars
	 * @param tabs
	 * @return String
	 */
	static public function create(vars:VarObj, ?tabs:String = '\t'):String {
		var title = convert.ShouldTitleTest.getShouldVarsTitle(vars);

		// TODO: not sure how to do FormControl so remove it for now
		// not sure what to do with this value, so for now I will comment the test
		var isFormControl = vars._content.indexOf('FormControl') != -1;
		var isFormGroup = vars._content.indexOf('FormGroup') != -1;

		var out = '';

		// out += '// this looks like an emtpy ngOnInit\n${tabs}';
		// out += '// Basic test with return type `${func.returnValue.type}`\n${tabs}';
		// out += '/**\n${tabs} *\t${func._content.replace('\n', '\n${tabs} *\t')}\n${tabs} */\n${tabs}';
		// out += '/**\n${tabs}';
		// log(func);

		out += '\n${tabs}';
		if (isFormControl || isFormGroup)
			out += '/**\n${tabs}';

		out += 'it(\'${title}\', () => {
${tabs}\t${spec.VarsObj2Test.create(vars, tabs)}
${tabs}});
';

		return out;
	}

	/**
	 * [Description]
	 * @param vars
	 * @param tabs
	 * @return String
	 */
	static public function components(vars:VarObj, ?tabs:String = '\t'):String {
		return create(vars, tabs);
	}

	/**
	 * [Description]
	 * @param vars
	 * @param tabs
	 * @return String
	 */
	static public function services(vars:VarObj, ?tabs:String = '\t'):String {
		var title = convert.ShouldTitleTest.getShouldVarsTitle(vars);

		// TODO: not sure how to do FormControl so remove it for now
		// not sure what to do with this value, so for now I will comment the test
		var isFormControl = vars._content.indexOf('FormControl') != -1;
		var isFormGroup = vars._content.indexOf('FormGroup') != -1;

		var out = '';

		out += '\n${tabs}';
		if (isFormControl || isFormGroup)
			out += '/**\n${tabs}';

		out += 'it(\'${title}\', () => {
${tabs}\t${spec.VarsObj2Test.services(vars, tabs)}
${tabs}});
';

		return out;
	}
}
