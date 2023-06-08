package;

/**
 * AST = Abstract Syntax Tree
 */
typedef TypeScriptClassObject = {
	var isFinished:Bool; // false,
	var hasHttpClient:Bool; // false,
	var hasConstructor:Bool; // false,
	var hasOnInit:Bool; // false,
	var hasOnChanged:Bool; // false,
	var hasUrl:Bool; // false,
	var URL:String; // :'', // guessing
	var constructor:TypeScriptConstructorObject;
	var imports:Array<String>;
	var functions:Array<FuncObj>;
	var vars:Array<VarObj>;
	var subscribes:Array<SubScribeObj>;
}

typedef TypeScriptConstructorObject = {
	var params:Array<TypedObj>;
}

// @example this.configSettingsService.getData().subscribe
typedef SubScribeObj = {
	var name:String; // var-name
	var call:String; // call
	var _content:String; // the original value
}

typedef VarObj = {
	// var access:String; // private|public|none
	var name:String; // var-name
	var type:String; // type of var
	// var returnValue:TypedObj;
	// var params:Array<TypedObj>;
	var _content:String; // the original value
	@:optional var optional:Bool; // `?`
	@:optional var nonnull:Bool; // `!`
	@:optional var _guessing:GuessingObj;
	@:optional var decorators:DecoratorsObj;
	@:optional var value:String;
}

typedef DecoratorsObj = {
	@:optional var input:Bool;
	@:optional var output:Bool;
}

/**
 * used to define a function
 *
 * ```ts
 * private functionName(param:string, param2:IType[]): Observable<IConfigSettings> {
 * 		// something clever
 * }
 * ```
 */
typedef FuncObj = {
	var access:String; // private|public|none
	var name:String; // function-name
	var returnValue:TypedObj;
	var params:Array<TypedObj>;
	var _content:String; // the original value
	@:optional var _guessing:GuessingObj;
}

/**
 * just a place to collect data that I am "guessing"
 *
 */
typedef GuessingObj = {
	@:optional var URL:String; // get this specific url for this function (is weird?)
	@:optional var requestType:String; // POST|GET (weird?)
}

/**
 * Convert a type to an object
 *
 *
 * Examples that should work
 *
 * ## returnvalue
 *
 * - `Observable<IConfigSettings>`
 * - `bool`
 * - `ITerm[]`
 *
 * ## param type
 *
 */
typedef TypedObj = {
	@:optional var access:String; // private|public|none|null (not for return types)
	@:optional var name:String; // not sure
	var value:String; // IConfigSettings
	var type:String; // Observable, Boolean, String, whatever,
	var _content:String; // the original value: Observable<IConfigSettings>
	@:optional var _guessing:GuessingObj;
}
