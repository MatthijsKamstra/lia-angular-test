package utils;

import const.Config;

class GeneratedBy {
	static public function init(type:String) {
		var message = "Generated file: ask Matthijs";
		if (type == 'js' || type == 'ts') {
			return '/* ${message} */';
		} else {
			return '<!-- ${message} -->';
		}
	}

	static public function message(type:String) {
		var message = '- WARNING: this is a generated test. \n- Most likely you need to change and update this file. \n- Generated on: ${DateTools.format(Date.now(), "%F")}\n- Version: ${Config.VERSION}';
		var message2 = '- Generated on: ${DateTools.format(Date.now(), "%F")}\n- Version: ${Config.VERSION}';
		if (type == 'js' || type == 'ts') {
			return '/*\n${message}\n*/';
		} else {
			return '<!--\n${message2}\n-->';
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
