package;

typedef FuncObj = {
	var URL:String; // get this specific url for this function
	var access:String; // private|public|none
	var name:String;
	var returnValue:TypedObj;
	var params:Array<TypedObj>;
	var _string:String; // the original value
	var requestType:String; // POST|GET
}

//  Observable<IConfigSettings>
typedef TypedObj = {
	@:optional var access:String; // private|public|none|null (not for return types)
	@:optional var name:String; // not sure
	var value:String; // IConfigSettings
	var type:String; // Observable, Boolean, String, whatever,
	var _string:String; // the original value: Observable<IConfigSettings>
}
