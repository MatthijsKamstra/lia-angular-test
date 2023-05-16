package spec;

class SpecService {
	var type:String;

	@:isVar public var variablesArray(get, set):Array<String> = [];
	@:isVar public var functionsArray(get, set):Array<String> = [];
	@:isVar public var servicesArray(get, set):Array<String> = [];
	@:isVar public var importArray(get, set):Array<String> = [];
	@:isVar public var constructorArray(get, set):Array<String> = [];
	@:isVar public var testBedArray(get, set):Array<String> = [];

	public function new(type:String) {
		this.type = type;
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

		return typescript(this.type, vars, funcs, imp, _constructor, _testBed);
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
	static public function typescript(name:String, vars:String = '', funcs:String = '', imports:String = '', constructor:String = '',
			testBed:String = ''):String {
		var template = '
import { TestBed } from \'@angular/core/testing\';
import { HttpClientTestingModule, HttpTestingController } from \'@angular/common/http/testing\';

import { SPEC_CONST } from \'../shared/spec-helpers/constants.spec-helper\';

import { ${Strings.toUpperCamel(name)}Service } from \'./${name.toLowerCase()}.service\';

${imports}

fdescribe(\'${Strings.toUpperCamel(name)}Service (Generated)\', () => {

	let service: ${Strings.toUpperCamel(name)}Service;
	let ${Strings.toLowerCamel(name)}Service: ${Strings.toUpperCamel(name)}Service; // [mck] might be removed in the future
${constructor}

	let httpMock: HttpTestingController;

	${vars}

	beforeEach(() => {
		TestBed.configureTestingModule({
			imports: [HttpClientTestingModule],
			providers: [${Strings.toUpperCamel(name)}Service]
		});
		service = TestBed.inject(${Strings.toUpperCamel(name)}Service);
		${Strings.toLowerCamel(name)}Service = TestBed.inject(${Strings.toUpperCamel(name)}Service); // [mck] might be removed in the future
${testBed}
		httpMock = TestBed.inject(HttpTestingController);
	});

	afterEach(() => {
		httpMock.verify();
	});

	it(\'should be created\', () => {
		expect(service).toBeTruthy();
	});

	${funcs}
});
';

		/*
			it(\'#getObservableValue should return value from observable\', (done: DoneFn) => {
				service.getObservableValue().subscribe(value => {
					expect(value).toBe(\'observable value\');
					done();
				});
			});
		 */
		/*
			it(\'should get users\', () => {
				const mockUsers = [
					{ name: \'Bob\', website: \'www.yessss.com\' },
					{ name: \'Juliette\', website: \'nope.com\' }
				];

				service.getData().subscribe((event: HttpEvent<any>) => {
					switch (event.type) {
						case HttpEventType.Response:
							expect(event.body).toEqual(mockUsers);
					}
				});

				const mockReq = httpMock.expectOne(service.url);
				expect(mockReq.cancelled).toBeFalsy();
				expect(mockReq.request.responseType).toEqual(\'json\');
				mockReq.flush(mockUsers);
			});
		 */

		return template;
	}

	// ____________________________________ add ____________________________________

	public function addConstructor(arg0:String) {
		this.constructorArray.push(arg0);
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
}
