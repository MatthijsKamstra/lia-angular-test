package utils;

// - https://regexr.com/
// - https://haxe.org/manual/std-regex.html
class RegEx {
	// ____________________________________ from {} ____________________________________
	public static final modifyCurlyBrackets = ~/({)+([\n\t\w\d\s,])+(})/g;
	public static final modifyImportCurlyBrackets = ~/(import)(.)({)+([\n\t\w\d\s,])+(})/g;
	// public static final objectCurlyBrackets = ~/(=.{)([\n\s\w:'",.])*(})/g;
	public static final modifyObject = ~/({)([\n\s\w:'",.])*(})/g;
	public static final modifyReturnValue = ~/(return.{)([\n\s\w:'",.])*(})/g;
	public static final modifyFunctionParams = ~/\(([\n\s\w:'",.])*\)/g;

	// ____________________________________ html ____________________________________
	// `[checked]="isChecked" >`
	public static var htmlAngularInput = ~/<.*\[.*\].*>/g;

	// `(change)="onChangeHandler(!isChecked)">`
	public static var htmlAngularOutput = ~/<.*\(.*\).*>/g;

	// `{{this.shape}}`
	public static var htmlAngularReactive = ~/<.*\{\{.*\}\}.*>/g;
	//
	public static var htmlAngularIfElse = ~/<.*\*ngIf.*>/g;

	// angular default components name
	public static var htmlAngularComponent = ~/<app-.*<\/app-.*>/g;

	// angular interpolation {{ }}
	public static var htmlInterpolation = ~/{{.*}}/g;

	// ____________________________________ typescript ____________________________________
	//
	// for example: `this.help = data;`
	public static var getVars = ~/(this.).+/g;

	// for example: `this.helpService.getData().subscribe({`
	public static var getSubscribe = ~/(this.).+(.subscribe)/g;

	// for example: `return environment.apiEnabled;`
	public static var getReturn = ~/(return)(.)*;/g;

	// find something that is called URL/url
	public static var hasURL = ~/(url|URL)(.)*/g;

	// basic test to check for function (only used to check for total)
	// extra check
	public static var classFunction = ~/([a-z0-9]+)\((.*)\):/g;

	// angular/js class imports
	public static var classImports = ~/import\s*.*/g;

	// angular/js class constructor
	public static var classConstructor = ~/constructor\s*\((\t|\n|\w|\s|:|,)*/g; // not the whole constructor, only the part with params

	// ____________________________________ comment ____________________________________
	public static final commentHTML = ~/<!--[\S\s]*?-->/g;
	public static final commentJS = ~/(\/\*)(.|\r|\n)*?(\*\/)/g;
	public static final commentJSLine = ~/(\/\/)[\S\s]*?/g;
	public static final commentJSLine3 = ~/(\/\/).*/g;
	public static final commentJSLine2 = ~/\/\*[\s\S]*?\*\/|\/\/.*/g;

	/**
		* search for specific regex
		*
		* @example
		* ```js
			var matches = RegEx.getMatches(RegEx.getVars, content);
			if (matches.length > 0) {
				// log(matches);
				for (i in 0...matches.length) {
					var match = matches[i];
					trace(match);
				}
			}
		* ```
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
