package utils;

using StringTools;

class TranslateName {
	/**
	 * convert filename to filename used by Angular
	 *
	 * @param val			filename
	 * @return String		converted filename
	 */
	static public function convert(val:String):String {
		val = val.replace(' ', '_').replace('.', '_').replace('/', '_').replace(':', '').replace(',', '').replace('-', '');

		if (val.substr(0, 1) == '_') {
			// trace(val.substr(0, 1), val);
			val = val.substr(1);
		}
		if (val.substr(val.length - 1, val.length) == '_') {
			// trace(val.substr(0, 1), val);
			val = val.substr(0, val.length - 1);
		}

		val = val.replace('__', '_');
		return val.toUpperCase();
	}
}
