package remove;

import utils.RegEx;

using StringTools;

class RemoveStuff {
	static public function all(content:String, templateType:String):String {
		content = RemoveComment.all(content, templateType);

		// {}
		info('[START] import - search and replace curly brackets');
		var _reg = RegEx.modifyImportCurlyBrackets;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length, 1);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('  ', ' ').replace('\r', '');
				// warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('[END] import - search and replace curly brackets');

		info('[START] object - search and replace curly brackets');
		var _reg = RegEx.modifyObject;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length, 1);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('    ', ' ').replace('  ', ' ').replace('\r', '');
				// warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('[END] object - search and replace curly brackets');

		info('[START] return  - search and replace curly brackets');
		var _reg = RegEx.modifyReturnValue;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length, 1);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('    ', ' ').replace('  ', ' ').replace('\r', '');
				// warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('[END] return - search and replace curly brackets');

		info('[START] function()  - search and replace curly brackets');
		var _reg = RegEx.modifyFunctionParams;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length, 1);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('    ', ' ').replace('  ', ' ').replace('\r', '');
				// warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('[END] function() - search and replace curly brackets');

		return content;
	}
}
