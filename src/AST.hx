package;

/**
 * AST = Abstract Syntax Tree
 */
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
	var URL:String; // get this specific url for this function (is weird?)
	var access:String; // private|public|none
	var name:String; // function-name
	var returnValue:TypedObj;
	var params:Array<TypedObj>;
	var requestType:String; // POST|GET
	var _content:String; // the original value
}

//  Observable<IConfigSettings>
typedef TypedObj = {
	@:optional var access:String; // private|public|none|null (not for return types)
	@:optional var name:String; // not sure
	var value:String; // IConfigSettings
	var type:String; // Observable, Boolean, String, whatever,
	var _content:String; // the original value: Observable<IConfigSettings>
}
