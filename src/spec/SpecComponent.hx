package spec;

import AST.TypeScriptClassObject;

class SpecComponent {
	public var type:String;
	public var obj:TypeScriptClassObject;

	@:isVar public var variablesArray(get, set):Array<String> = [];
	@:isVar public var functionsArray(get, set):Array<String> = [];
	@:isVar public var servicesArray(get, set):Array<String> = [];
	@:isVar public var importArray(get, set):Array<String> = [];
	@:isVar public var constructorArray(get, set):Array<String> = [];
	@:isVar public var testBedArray(get, set):Array<String> = [];
	@:isVar public var providerArray(get, set):Array<String> = [];

	public function new(type:String, obj:TypeScriptClassObject) {
		this.type = type;
		this.obj = obj;
	}

	public function create():String {
		// trace("WIP");
		var vars = '';
		for (i in 0...variablesArray.length) {
			var _variablesArray = variablesArray[i];
			vars += _variablesArray;
			if (i < variablesArray.length - 1) {
				vars += '\n\t';
			}
		}

		var funcs = '';
		for (i in 0...functionsArray.length) {
			var _functionsArray = functionsArray[i];
			funcs += _functionsArray;
			if (i < functionsArray.length - 1) {
				funcs += '\n\t';
			}
		}

		var imp = '';
		for (i in 0...importArray.length) {
			var _importArray = importArray[i];
			imp += _importArray;
			if (i < importArray.length - 1) {
				imp += '\n';
			}
		}

		var _constructor = '';
		for (i in 0...constructorArray.length) {
			var _constructorArray = constructorArray[i];
			_constructor += _constructorArray;
			if (i < constructorArray.length - 1) {
				_constructor += '\n';
			}
		}

		var _testBed = '';
		for (i in 0...testBedArray.length) {
			var _testBedArray = testBedArray[i];
			_testBed += _testBedArray;
			if (i < testBedArray.length - 1) {
				_testBed += '\n';
			}
		}

		var _provider = '';
		for (i in 0...providerArray.length) {
			var _providerArray = providerArray[i];
			// _provider += '${_providerArray}';
			// // TODO, remove other `TranslateService` ????
			if (_providerArray == 'TranslateService') {
				_provider += 'TranslateService, ';
			} else {
				// _provider += '{ provide: ${_providerArray}, \nuseValue: ${_providerArray}Spy }';
				_provider += '{ provide: ${_providerArray}, useValue: jasmine.createSpyObj(\'${_providerArray}\', [\'CHANGE-2-CORRECT-METHODENAME(S)\'])}';
			}
			//  jasmine.createSpyObj('GroupsService', ['searchGroup', 'save'])
			if (i < providerArray.length - 1) {
				_provider += ',';
			}
		}

		return typescript(this.type, vars, funcs, imp, _constructor, _testBed, _provider);
	}

	/**
	 * create a basic test (.spec) template for a service
	 * @param name
	 * @param vars
	 * @param funcs
	 * @param imports
	 * @param constructor
	 * @param testBed
	 * @return String
	 */
	public function typescript( //
		name:String, //
		vars:String = '', //
		funcs:String = '', //
		imports:String = '', //
		constructor:String = '', //
		testBed:String = '', //
			providers:String = '' //
	):String {
		var _isTranslateService = providers.indexOf('TranslateService') != -1;
		var _hasSpecHelper = false;
		var _hasRouter = imports.indexOf('Router') != -1;
		var _hasRouterTest = false;
		var _hasNav = false;
		var _hasHttpClient = this.obj.hasHttpClient;
		var _hasTranslate = providers.indexOf('TranslateService') != -1;
		var _hasTest:String = (true) ? "true" : "false";
		var _useTemplate:Bool = false;
		// warn(isTranslateService);

		var template = '
import { ComponentFixture, TestBed } from \'@angular/core/testing\';
import { TranslateModule } from \'@ngx-translate/core\';

${_hasHttpClient ? "import { HttpClientTestingModule, HttpTestingController } from \'@angular/common/http/testing\';" : ""}
${_hasHttpClient ? "import { HttpClient, HttpErrorResponse } from \'@angular/common/http\';" : ""}
${_hasHttpClient ? "import { NO_ERRORS_SCHEMA } from \'@angular/core\';" : ""}

${_hasTranslate ? "import { NgxTranslateModule } from \'src/app/module/translate/translate.module\';" : ""}
${_hasTranslate ? "import { TranslateModule } from \'@ngx-translate/core\';" : ""}
${_hasRouterTest ? "import { RouterTestingModule } from \'@angular/router/testing\';" : ""}
${_hasRouter ? "// import { Router } from \'@angular/router\';" : ""}

${_hasSpecHelper ? "import { SPEC_CONST } from \'src/app/shared/spec-helpers/constants.spec-helper\';" : ""}

import { ${Strings.toUpperCamel(name)}Component } from \'./${name.toLowerCase()}.component\';

${imports}

fdescribe(\'${Strings.toUpperCamel(name)}Component (Generated)\', () => {

	let component: ${Strings.toUpperCamel(name)}Component;
	let fixture: ComponentFixture<${Strings.toUpperCamel(name)}Component>;
	//
${_hasTranslate ? "	let translate: TranslateService;" : ""}
${_hasHttpClient ? "	let httpClient: HttpClient;" : ""}
${_hasHttpClient ? "	let httpTestingController: HttpTestingController;" : ""}

${_hasNav ? "	let navigateSpy: jasmine.Spy;" : ""}

${constructor}

${vars}

	beforeEach(async () => {
		await TestBed.configureTestingModule({
			imports: [
				TranslateModule.forRoot(),
${_hasHttpClient ? "				HttpClientTestingModule," : ""}
${_hasTranslate ? "				NgxTranslateModule," : ""}
${_hasTranslate ? "				TranslateModule.forRoot()," : ""}
${_hasRouterTest ? "				RouterTestingModule.withRoutes([])" : ""}
			],
			declarations: [${Strings.toUpperCamel(name)}Component],
			providers: [${providers}],
${_hasHttpClient ? "			schemas: [NO_ERRORS_SCHEMA]," : ""}
		}).compileComponents();
		//
${testBed}

${_hasHttpClient ? "		httpClient = TestBed.inject(HttpClient);" : ""}
${_hasHttpClient ? "		httpTestingController = TestBed.inject(HttpTestingController);" : ""}
${_hasNav ? "		navigateSpy = spyOn(router, \'navigate\');" : ""}
${_hasTranslate ? "		translate = TestBed.inject(TranslateService);" : ""}
		//
		fixture = TestBed.createComponent(${Strings.toUpperCamel(name)}Component);
		component = fixture.componentInstance;
		fixture.detectChanges();
${_useTemplate ? "
		// const formGroupEl = fixture.debugElement.query(By.directive(FakeFormGroupComponent));
		// formGroup = formGroupEl.componentInstance;
		// saveButton = fixture.debugElement.query(By.css('[data-testid='saveButton']')).nativeElement;" : ""}
	});

${_hasHttpClient ? "	afterEach(() => {
		httpTestingController.verify();
	});" : ""}

	it(\'should create\', () => {
		expect(component).toBeTruthy();
	});

	${funcs}
});
';

		return template;
	}

	// ____________________________________ add ____________________________________

	public function addConstructor(arg0:String) {
		this.constructorArray.push(arg0);
	}

	public function addProviders(arg0:String) {
		this.providerArray.push(arg0);
	}

	public function addTestbed(arg0:String) {
		this.testBedArray.push(arg0);
	}

	public function addVariable(arg0:String) {
		this.variablesArray.push(arg0);
	}

	public function addImport(arg0:String) {
		this.importArray.push(arg0);
	}

	public function addFunction(arg0:String) {
		this.functionsArray.push(arg0);
	}

	// ____________________________________ getter/setter ____________________________________

	function get_variablesArray():Array<String> {
		return variablesArray;
	}

	function set_variablesArray(value:Array<String>):Array<String> {
		return variablesArray = value;
	}

	function get_functionsArray():Array<String> {
		return functionsArray;
	}

	function set_functionsArray(value:Array<String>):Array<String> {
		return functionsArray = value;
	}

	function get_servicesArray():Array<String> {
		return servicesArray;
	}

	function set_servicesArray(value:Array<String>):Array<String> {
		return servicesArray = value;
	}

	function get_importArray():Array<String> {
		return importArray;
	}

	function set_importArray(value:Array<String>):Array<String> {
		return importArray = value;
	}

	function get_constructorArray():Array<String> {
		return constructorArray;
	}

	function set_constructorArray(value:Array<String>):Array<String> {
		return constructorArray = value;
	}

	function get_testBedArray():Array<String> {
		return testBedArray;
	}

	function set_testBedArray(value:Array<String>):Array<String> {
		return testBedArray = value;
	}

	function get_providerArray():Array<String> {
		return providerArray;
	}

	function set_providerArray(value:Array<String>):Array<String> {
		return providerArray = value;
	}
}
