package utils;

// - https://regexr.com/
// - https://haxe.org/manual/std-regex.html
class RegEx {
	// angular/js class imports
	public static var classImports = ~/import\s*.*/g;

	// angular/js class constructor
	public static var classConstructor = ~/constructor\s*\((\t|\n|\w|\s|:|,)*/g; // not the whole constructor, only the part with params

	//
	//
	//
	//
	//
	//
	//
	public static var jsVars = ~/\w*\s*:\s*\{(\t|\n|\r)*[^}]*}/g;

	// closeBanner : function() { service.bannerClosedThisSession = true;},
	// closeBanner: function() { service.bannerClosedThisSession = true;},
	// public static var jsFunctions = ~/.*function\(\)\s*\{\n[\t\n\s\w\.;=]*},/g;
	public static var jsFunctions = ~/\w*\s*:\s*function\(.*\)/g;

	public static var jsaaaaFunctions = ~/([a-z0-9]+)\((.*)\)(\t|\r|\s)*\W|\s([a-z0-9]+)\((.*)\)(\t|\r|\s)*\W/g;
	// .*function\(.*\)\s*\{(\t|\r|\s)*(.*)
	// .*function\(.*\)\s*\{\n[\r\t\n\s\w\d\.\;\=]*},
	//	search `"banner.start"` (object)
	//	search `banner.start` (object)
	// public static var objects = ~/[\w\S]*\.[\w\S]*/g;
	public static var objects = ~/[\w]*\.[\w]+/g;

	// public static var objects = ~/(?<!"'\s{)[\w\S]*\.[\w\S]*(?!"'\s})/g;
	// seach for `"functionsName()"`
	public static var functions = ~/"[.\S]*\(\)"/g; // first try

	// public static var functions = ~/"\s*\([\S\s]*?\)/g;
	// find functions
	public static final objControllerFunctions = ~/,\s*function\s*\([\S\s]*?\)/g; // TODO: might need to check for `$scope`

	// comment
	public static final commentHTML = ~/<!--[\S\s]*?-->/g;
	public static final commentJS = ~/(\/\*)(.|\r|\n)*?(\*\/)/g;
	public static final commentJSLine = ~/(\/\/)[\S\s]*?/g;
	public static final commentJSLine2 = ~/\/\*[\s\S]*?\*\/|\/\/.*/g;

	// string literals
	public static final templateLiterals = ~/\${[\S\s]*?}/g;

	// rootURL
	public static var rootURL = ~/.*rootURL.*/g;

	// $resources
	public static final resourcez = ~/\$resource\([\S\s]*?\)/g;

	// Interpolation refers	to	embedding	expressions	into	marked	up	text.
	// By default, interpolation uses the double curly braces `{{` and `}}` as delimiters.
	public static final doubleCurlyBraces = ~/{{[\S\s]*?}}/g;

	//
	// icons
	public static final iconGlyphicon = ~/glyphicon glyphicon-[\S\s]*?["']/g;
	public static final iconFontAwesome = ~/fa fa-[\S\s]*?["']/g;
	public static final htmlClass = ~/\s\bclass=("[^"]+")/g;

	/*
		{
		url : '/reports',
		controller : 'ReportsCtrl',
		templateUrl : 'views/reports.html'
		}
	 */
	public static final objUrl = ~/url.?:.?["'][\S\s]*?["']/g;
	public static final objController = ~/controller.?:.?["'][\S\s]*?["']/g;
	public static final objTemplateUrl = ~/templateUrl.?:.?["'][\S\s]*?["']/g;

	public static final functionController = ~/.controller\(.?["'][\S\s]*?["'],[\S\s]*?\n\}\)/g;

	// public static function funcController(controller:String):EReg {
	// 	return ~/.controller\(.?["'][\S\s]*?["'],[\S\s]*?\}\)/g;
	// 	// return ~/.controller\(.?["']${controller}["'],[\S\s]*?\}\)/g;
	// }
	/*
		var href = ~/href="([^'"]+)/g;
		var form = ~/<form\s.*>[\S\s]*?<\/form>/g;
		var bgimg = ~/url\([\S\s]*?\)/g;
		var img = ~/<img[\S\s]*?>/g;
	 */
	public static final href = ~/ href="([^'"]+)/g;
	public static final style = ~/style="([^'"]+)"/g;
	public static final id = ~/ id="([^'"]+)/g;
	public static final classes = ~/ class="([^'"]+)/g;

	// ng-if="!newSchedule"
	public static final ng = ~/\sng-([a-z]+)=["]([^".]+)["]/g;

	/**
		* search for specific regex
		*
		* @example
			```js
			var matches = R.getMatches(commentReg, content);
			if (matches.length > 0) {
				// log(matches);
				for (i in 0...matches.length) {
					var match = matches[i];
					trace(match);
				}
			}
			```
		*
		* @param ereg
		* @param input
		* @param index
		* @return Array<String>
	 */
	static public function getMatches(ereg:EReg, input:String, index:Int = 0):Array<String> {
		var matches = [];
		while (ereg.match(input)) {
			matches.push(ereg.matched(index));
			input = ereg.matchedRight();
		}
		return matches;
	}
}
