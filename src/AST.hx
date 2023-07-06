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

typedef HTMLClassObject = {
	var fileName:String; // "ddd",
	var name:String; //  app-icons
	var type:String; // IconsComponent
	var className:String; // IconsComponent
	var dataTestID:String; //  app-icons
	var hasDataTestID:Bool; //  <app-icons data-testid="app-icons" data-testid
	var _content:String; // the original value
	var components:Array<ComponentObject>;
	var interpolations:Array<BasicObject>;
	var inputs:Array<BasicObject>;
	var outputs:Array<BasicObject>;
	var ngif:Array<NgIfObject>;
	var isFinished:Bool; // false,
}

typedef BasicObject = {
	var dataTestID:String; //  app-icons
	var _value:String; //  {{this.shape}}
	var value:String; //  {{this.shape}}
	@:optional var valueFunction:BasicFunctionObject; //
	@:optional var property:String; //
	@:optional var _property:String; //
	var hasDataTestID:Bool; //  <app-icons data-testid="app-icons" data-testid
	var _content:String; // the original value
}

typedef BasicFunctionObject = {
	var name:String;
	@:optional var param:String;
	@:optional var params:Array<String>;
}

typedef ComponentObject = {
	var name:String; //  app-icons
	var type:String; // IconsComponent
	var className:String; // IconsComponent
	var _content:String; // the original value
	var hasDataTestID:Bool; //  <app-icons data-testid="app-icons" data-testid
	var functions:Array<FuncObj>;
	var inputs:Array<InputObj>; //  icon="{{getIcon()}}"
}

typedef NgIfObject = {
	@:optional var _id:String;
	var hasDataTestID:Bool; //  <app-icons data-testid="app-icons" data-testid
	var _content:String; // the original value
}

typedef InputObj = {
	var name:String; //  icon="{{getIcon()}}"
	@:optional var _test:String; //  icon="{{getIcon()}}"
}

typedef TypeScriptConstructorObject = {
	var params:Array<TypedObj>;
}

// @example this.configSettingsService.getData().subscribe
typedef SubScribeObj = {
	var name:String; // var-name
	var call:{
		name:String,
		param:String,
	}
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
