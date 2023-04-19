package utils;

class FileName {
	/**
	 * convert filename to filename used by Angular in files
	 *
	 * @example
	 *
	 * 		- 'test me' == 'test-me'
	 *
	 *
	 * @param val			filename
	 * @return String		converted filename
	 */
	static public function convert(val:String):String {
		// simple replace
		// - dot into dash
		// - remove -tpl
		val = val.trim().replace('.', '-').replace(' ', '-').replace('-tpl', '');
		val = val.charAt(0).toLowerCase() + val.substr(1);
		// split camelCase
		// `validationService` becomes `validation-Service`
		// for (i in 0...val.split('').length) {
		// 	var character = val.split('')[i];
		// 	if (character == '-')
		// 		continue;
		// 	if (!Math.isNaN(Std.parseFloat(character)))
		// 		continue;
		// 	if (character == character.toUpperCase()) {
		// 		// trace(character);
		// 	}
		// }

		// trace('"$val": ${val.length}');

		var j = 0;
		while (j < val.length) {
			var character = val.charAt(j);
			if (character == '-') {
				j++;
				// trace('ignore dash');
				continue;
			}
			if (!Math.isNaN(Std.parseFloat(character))) {
				j++;
				// trace('ignore numbers');
				continue;
			}
			// trace(character);
			if (character == character.toUpperCase()) {
				// trace(character);
				// var str = val.substr(0, j) + '-${character.toLowerCase()}' + val.substr(j + 1);
				// trace(str);
				val = val.substr(0, j) + '-${character.toLowerCase()}' + val.substr(j + 1);
			}
			j++;

			// ugh while loops are difficult
			if (j > 50) {
				warn('more then 50');
				break;
			}
		}

		// var str = 'fooBar';
		// str = str.substr(0, 3) + '_' + str.substr(3);
		// trace(str);

		return val.toLowerCase();
	}

	/**
	 * [Description]
	 * @param val
	 * @return String
	 */
	static public function reConvert(val:String):String {
		return Strings.toUpperCamel(val);
	}
}
