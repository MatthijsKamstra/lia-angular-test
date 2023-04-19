package utils;

import sys.FileSystem;

/**
	* How to use
	* @example
	*
	*```
		var isFileExists = DoesThisFile.exists('${Folder.DIST}/${Project.NAME}/src/pages/test/filelinesize-overview-page');
		if (!isFileExists) {
			// so file doesn't exist, do something clever
		}

		// or

		if (!DoesThisFile.exists('${Folder.DIST}/${Project.NAME}/src/pages/test/filelinesize-overview-page')) {
			// so file doesn't exist, do something clever
		}
	*```
	*
	*
 */
class DoesThisFile {
	public static var fileExistsArr:Array<String> = [];

	/**
	 * [Description]
	 * @param path
	 * @return Bool
	 */
	static public function exists(path:String, isDebug:Bool = false):Bool {
		var bool = false;
		if (!fileExistsArr.contains(path)) {
			if (isDebug)
				warn('Not in the static yet for ${path}');
			bool = FileSystem.exists(path);
			if (isDebug)
				warn('exists? ${bool}');
			if (bool) {
				if (isDebug)
					warn('Use FileSystem for ${path}');
				fileExistsArr.push(path);
			}
		} else {
			// file exists in fileExistsArr
			bool = true;
		}
		return bool;
	}
}
