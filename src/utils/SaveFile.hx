package utils;

import haxe.io.Path;

using StringTools;

class SaveFile {
	static public function out(path:String, str:String) {
		// write the file
		sys.io.File.saveContent(path, str);
	}

	/**
	 * [Description]
	 * @param path
	 * @param map
	 */
	static public function stringMapArray(path:String, map:Map<String, Array<String>>) {
		var str = '# ${Path.withoutDirectory(path)}\n\n';
		str += 'Total paths: ${Lambda.count(map)}\n';
		str += '\n';
		for (key in map.keys()) {
			var arr = map[key];
			str += '## ${Path.withoutDirectory(key)}\n\n';
			str += 'Path: `${stripPath(key)}`\n';
			str += 'File: "${Path.withoutDirectory(key)}"\n\n';
			// trace('$key is $arr years old');
			for (i in 0...arr.length) {
				var item = arr[i];
				str += '- `${item}`\n';
			}
			str += '\n\n';
		}
		// write the file
		sys.io.File.saveContent(path, str);
	}

	/**
	 * [Description]
	 * @param path
	 * @param arr
	 */
	public static function writeArray(path:String, arr:Array<Dynamic>) {
		var str = '# ${Path.withoutDirectory(path)}\n\n';
		str += 'Total files: ${arr.length}\n';
		str += '\n';
		for (i in 0...arr.length) {
			var line:String = arr[i];
			// remove whole path to make it more readable
			str += '- ${stripPath(line)}\n';
		}
		// write the file
		sys.io.File.saveContent(path, str);
	}

	public static function stripPath(path:String):String {
		return path.replace('/Users/matthijskamstra/Documents/workingdir/Alliander/osgp-applications/public-lighting', '/public-lighting');
	}
}
