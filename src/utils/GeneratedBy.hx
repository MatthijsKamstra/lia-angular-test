package utils;

class GeneratedBy {
	static public function init(type:String) {
		var message = "Generated file: ask Matthijs";
		if (type == 'js' || type == 'ts') {
			return '/* ${message} */';
		} else {
			return '<!-- ${message} -->';
		}
	}

	static public function warning(type:String) {
		var message = "Generated code, be carefull with modification or \"blind\" implementation";
		if (type == 'js' || type == 'ts') {
			return '/* ${message} */';
		} else {
			return '<!-- ${message} -->';
		}
	}

	static public function info(type:String) {
		var message = "Generated file: ask Matthijs";
		if (type == 'js' || type == 'ts') {
			return '/* ${message} */';
		} else {
			return '<!-- ${message} -->';
		}
	}
}
