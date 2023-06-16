package spec.convert;

import AST.FuncObj;

class TestObservable {
	/**
	 * GENERIC
	 */
	static public function create(func:FuncObj, tabs:String = '\t'):String {
		return '/**
		${build(func, tabs)}
		*/';
	}

	/**
	 * COMPONENTS
	 */
	static public function components(func:FuncObj, tabs:String = '\t'):String {
		return '${build(func, tabs)}';
	}

	/**
	 * SEVICES
	 */
	static public function services(func:FuncObj, tabs:String = '\t'):String {
		return '${build(func, tabs)}';
	}

	/**
	 * [Description]
	 * @param func
	 * @param tabs
	 * @return String
	 */
	static private function build(func:FuncObj, tabs:String = '\t'):String {
		var out = '';
		out += '
${tabs}xit(\'#should call "${func.name}" with return `Observable<${func.returnValue.value}>`\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\t// url used (TODO: check if this value is correct)
${tabs}\t${ConvertURL(func)}
${tabs}\t// Act
${tabs}\t${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\tconst testRequest = httpTestingController.expectOne(_url);
${tabs}\texpect(testRequest.request.url).toBe(_url);
${tabs}\texpect(testRequest.request.method).toBe("${(func._guessing.requestType)}");
${tabs}\texpect(testRequest.cancelled).toBeFalsy();
${tabs}\texpect(testRequest.request.responseType).toEqual(\'json\');
${tabs}\ttestRequest.flush(_param${Strings.toUpperCamel(func.params[0].name)});
${tabs}});
${tabs}
${tabs}it(\'#should call "${func.name}" with return `Observable<${func.returnValue.value}>`\', (done: DoneFn) => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\tconst _IValue: IValue = SPEC_CONST.getValue(IValue);
${tabs}\t// url used (TODO: check if this value is correct)
${tabs}\t${ConvertURL(func)}
${tabs}\t// Act
${tabs}\t// ${FunctionCall.services(func, tabs)}
${tabs}\t// create the service call
${tabs}\t// TODO: command click on "${func.name}(_param${Strings.toUpperCamel(func.params[0].name)})" to see what value it will return
${tabs}\tservice.${func.name}(_param${Strings.toUpperCamel(func.params[0].name)}).subscribe(value => {
${tabs}\t	expect(value).toBe(_IValue);
${tabs}\t	done();
${tabs}\t});
${tabs}\t// Assert
${tabs}\tconst testRequest = httpTestingController.expectOne(_url);
${tabs}\texpect(testRequest.request.url).toBe(_url);
${tabs}\texpect(testRequest.request.method).toBe("${(func._guessing.requestType)}");
${tabs}\texpect(testRequest.cancelled).toBeFalsy();
${tabs}\texpect(testRequest.request.responseType).toEqual(\'json\');
${tabs}\ttestRequest.flush(_IValue);
${tabs}});
${tabs}
${tabs}it(\'#should spy on "${func.name}" call and return dummy data\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\tconst _IValue: IValue = SPEC_CONST.getValue(IValue);
${tabs}\t// command click on "${func.name}()" to see what value it will return
${tabs}\tconst _spy = spyOn(service, \'${func.name}\').and.returnValue(of(_IValue));
${tabs}\t// Act
${tabs}\t${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(service.${func.name}).toHaveBeenCalledWith(_param${Strings.toUpperCamel(func.params[0].name)});
${tabs}});
${tabs}
${tabs}it(\'#can test HttpClient.${func._guessing.requestType.toLowerCase()} in "${func.name}"\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\tconst _url: string = "/test";
${tabs}\tconst _data: any = { name: \'Test Data\' };
${tabs}\t// Act
${tabs}\thttpClient.${func._guessing.requestType.toLowerCase()}<${func.returnValue.value}>(_url).subscribe(data => {
${tabs}\t	expect(data).toEqual(_data);
${tabs}\t});
${tabs}\t// Assert
${tabs}\tconst testRequest = httpTestingController.expectOne(_url);
${tabs}\texpect(testRequest.request.method).toEqual(\'${func._guessing.requestType}\');
${tabs}\t//
${tabs}\ttestRequest.flush(_data);
${tabs}\t// httpTestingController.verify();
${tabs}});
${tabs}
${tabs}it(\'#should call http.${func._guessing.requestType.toLowerCase()} and set data in "${func.name}"\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\tconst _url = "/test";
${tabs}\tconst _data: any = { name: \'Test Data\' };
${tabs}\tconst _spy: jasmine.Spy<${func.returnValue.value}> = spyOn(httpClient, \'${func._guessing.requestType.toLowerCase()}\').and.returnValue(of(_data));
${tabs}\t// Act (should call the tested function itself)
${tabs}\t${FunctionCall.services(func, tabs)}
${tabs}\t// Assert
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}\t// expect(_spy).toHaveBeenCalledOnceWith(_url); // FIXME
${tabs}\t// expect(service.${func.name}).toEqual(_data); // FIXME
${tabs}});
${tabs}
${tabs}it(\'#can test for 404 error in "${func.name}"\', () => {
${tabs}\t// Arrange
${tabs}\t${FunctionParams.services(func, tabs)}
${tabs}\tconst _url: string = "/test";
${tabs}\tconst _data: any = { status: 404, statusText: "Not Found" }
${tabs}\tconst _msg = \'deliberate 404 error\';
${tabs}\t// Act
${tabs}\thttpClient.${func._guessing.requestType.toLowerCase()}<any>(_url).subscribe({
${tabs}\t	next: () => { fail(\'should have failed with the 404 error\'); },
${tabs}\t	error: (error: HttpErrorResponse) => {
${tabs}\t		expect(error.status).withContext(\'status\').toEqual(404);
${tabs}\t		expect(error.error).withContext(\'message\').toEqual(_msg);
${tabs}\t		expect(error).toEqual(error);
${tabs}\t	}
${tabs}\t});
${tabs}\t// Assert
${tabs}\tconst req = httpTestingController.expectOne(_url);
${tabs}\texpect(req.request.method).toEqual(\'${func._guessing.requestType}\');
${tabs}\t//
${tabs}\treq.flush(_msg, _data);
${tabs}\thttpTestingController.verify();
${tabs}});
${tabs}
${(false)?'
/**
${haxe.Json.stringify(func, null, '\t')}
*/
':''}
${tabs}';

		return out;
	}

	static function ConvertURL(func:FuncObj):String {
		var url = func._guessing.URL;
		url = url.replace('this.', '') //
			.replace('url ', '_url ') //
			.replace('${func.params[0].name}', '_param${Strings.toUpperCamel(func.params[0].name)}');
		if (url == '')
			url = '_url: string = "/test";';
		return 'const ' + url;
	}
}
