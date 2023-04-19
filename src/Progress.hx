class Progress {
	public static var doneFileArr:Array<String> = [];

	public static function update(file:String) {
		if (!doneFileArr.contains(file)) {
			doneFileArr.push(file);
		}
	}

	/**
	 * simple wrapper arround done and total array
	 * @param str
	 * @param doneArr
	 * @param totalArr
	 */
	public static function wrapper(str, doneArr:Array<Dynamic>, totalArr:Array<Dynamic>) {
		progress('${str}: ${doneArr.length}/${totalArr.length} (${Math.round((doneArr.length / totalArr.length) * 100)}%)');
	}
}
