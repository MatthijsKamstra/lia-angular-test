package remove;

import utils.RegEx;

using StringTools;

class RemoveComment {
	static public function all(content:String, templateType:String):String {
		var _commentReg = RegEx.commentJSLine3;
		var matches = RegEx.getMatches(_commentReg, content);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				content = content.replace(match, '');
			}
		}

		_commentReg = RegEx.commentHTML;
		if (templateType != 'html') {
			// warn('Comments in JS files don\'t work yet!');
			_commentReg = RegEx.commentJS;
		}

		// if (content.indexOf('<!--') != -1) {
		var matches = RegEx.getMatches(_commentReg, content);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// trace(match);
				content = content.replace(match, '');
			}
		}
		// copyright comment removed
		// }

		_commentReg = RegEx.commentJSLine2;
		var matches = RegEx.getMatches(_commentReg, content);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// trace(match);
				content = content.replace(match, '');
			}
		}

		return content;
	}

	/**
	 * [Description]
	 * @param content
	 * @param templateType 		is it `html` or !`html` aka `js`/`ts`
	 * @return String
	 */
	static public function copyright(content:String, templateType:String):String {
		var _commentReg = RegEx.commentHTML;
		if (templateType != 'html') {
			warn('Comments in JS files don\'t work yet!');
			// _commentReg = RegEx.commentJS;
		}

		var matches = RegEx.getMatches(_commentReg, content);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// trace(match);
				if (match.indexOf('Copyright') != -1) {
					// remove copyright comment
					content = content.replace(match, '');
				}
			}
		}
		// copyright comment removed
		return content;
	}
}
