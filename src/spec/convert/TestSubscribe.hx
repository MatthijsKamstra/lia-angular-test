package spec.convert;

import utils.GenValues;
import AST.SubScribeObj;

class TestSubscribe {
	static public function create() {
		//
	}

	/**
	 * [Description]
	 * @param sub
	 * @param tabs
	 * @return String
	 */
	static public function components(sub:SubScribeObj, ?tabs:String = '\t'):String {
		var out = '';
		out += '
${tabs}it(\'#should spy on "${sub.name}" call "${sub.call}" and return dummy data\', () => {
${tabs}\t// Arrange
${tabs}\tconst _IValue: IValue = SPEC_CONST.getValue(IValue);
${tabs}\t// command click on "${sub.call.name}()" to see what value it will return
${tabs}\t${sub.name}Spy.${sub.call.name}.and.returnValue(of(_IValue));
${tabs}\t// Act
${tabs}\tcomponent.help = _IValue;
${tabs}\tcomponent.ngOnInit();
${tabs}\t// Assert
${tabs}\texpect(component.help).toBe(_IValue);
${tabs}});
${tabs}
${tabs}/*
${tabs}// dummy test to write a quick test (!)
${tabs}it(\'#should test "${sub.name}" with call "${sub.call}"\', () => {
${tabs}\t// Arrange
${tabs}\t// Act
${tabs}\t// Assert
${tabs}});
${tabs}*/;
${tabs}
${tabs}it(\'#should set "${sub.name}" errorMessage and error if http.get returns an error\', () => {
${tabs}\t// Arrange
${tabs}\tconst _url: string = "/test";
${tabs}\tconst _errorMessage = \'deliberate 404 error\';
${tabs}\tconst _error: any = { error: _errorMessage, status: 404, statusText: "Not Found" };
${tabs}\t${sub.name}Spy.${sub.call.name}.and.returnValue(throwError(() => _error));
${tabs}\t// Act
${tabs}\tcomponent.ngOnInit();
${tabs}\t// Assert
${tabs}\texpect(${sub.name}Spy.${sub.call.name}).toHaveBeenCalled();
${tabs}\texpect(notificationService.error).toHaveBeenCalled();
${tabs}});
${tabs}
${tabs}it(\'#should set "${sub.name}" errorMessage and error if http.get returns an error and calls notificationService\', () => {
${tabs}\t// Arrange
${tabs}\tconst _errorMessage = "Er is een fout opgetreden bij het ophalen van het online help document.";
${tabs}\tconst _error: any = { error: _errorMessage, status: 404, statusText: "Not Found" };
${tabs}\tconst _HttpErrorResponse: HttpErrorResponse = {
${tabs}\t\tname: \'HttpErrorResponse\',
${tabs}\t\tmessage: "",
${tabs}\t\terror: _error,
${tabs}\t\tok: false,
${tabs}\t\theaders: new HttpHeaders,
${tabs}\t\tstatus: 0,
${tabs}\t\tstatusText: "",
${tabs}\t\turl: null,
${tabs}\t\ttype: HttpEventType.ResponseHeader
${tabs}\t};
${tabs}\t${sub.name}Spy.${sub.call.name}.and.returnValue(throwError(() => _HttpErrorResponse));
${tabs}\t// Act
${tabs}\tcomponent.ngOnInit();
${tabs}\t// Assert
${tabs}\texpect(notificationServiceSpy.error).toHaveBeenCalledWith(_errorMessage);
${tabs}});
${tabs}\n';

		return out;
	}

	/**
	 * [Description]
	 * @param sub
	 * @param tabs
	 * @return String
	 */
	static public function services(sub:SubScribeObj, ?tabs:String = '\t'):String {
		var out = '';
		// it('#should spy "configSettingsService" ngOnInit with `IHelp` value', () => {
		out += '
${tabs}it(\'#should test ${sub.name}Client.get\', () => {
${tabs}\t// Arrange
${tabs}\tconst _url: string = "/${GenValues.string().toLowerCase()}";
${tabs}\tconst _data: any = { name: \'Test Data\' };
${tabs}\t// Act
${tabs}\t${sub.name}Client.get<any>(_url).subscribe(data => {
${tabs}\t	expect(data).toEqual(_data);
${tabs}\t});
${tabs}\t// Assert
${tabs}\tconst testRequest = httpTestingController.expectOne(_url);
${tabs}\texpect(testRequest.request.method).toEqual(\'GET\');
${tabs}\ttestRequest.flush(_data);
${tabs}});
${tabs}
${tabs}// WIP
${tabs}/*
${tabs}it(\'should call the function with the subscribe in it "${sub.name}Client" \', () => {
${tabs}\t// Arrange
${tabs}\tconst _url: string = "/${GenValues.string().toLowerCase()}";
${tabs}\tconst _spy = spyOn(service, "[functionName]"); // the function with the subscribe function in it
${tabs}\t// Act
${tabs}\tservice.[functionName](); // the function with the subscribe function in it
${tabs}\t// Assert
${tabs}\texpect(_spy).toHaveBeenCalled();
${tabs}});
${tabs}*/
${tabs}
${tabs}// WIP
${tabs}it(\'should call http.get and set data\', () => {
${tabs}\t// Arrange
${tabs}\tconst _url: string = "/${GenValues.string().toLowerCase()}";
${tabs}\tconst _data: any = { name: \'Test Data\' };
${tabs}\tconst _spy = spyOn(httpClient, \'get\').and.returnValue(of(_data));
${tabs}\t// Act
${tabs}\tservice.onSubmit(_url); // TODO should call the tested function itself
${tabs}\t// Assert
${tabs}\texpect(_spy).toHaveBeenCalledOnceWith(_url);
${tabs}\t// expect(service.data).toEqual(_data);
${tabs}});
${tabs}
${tabs}it(\'can test for 404 error\', () => {
${tabs}\t// Arrange
${tabs}\tconst _url: string = "/${GenValues.string().toLowerCase()}";
${tabs}\tconst _data: any = { status: 404, statusText: "Not Found" }
${tabs}\tconst _msg = \'deliberate 404 error\';
${tabs}\t// Act
${tabs}\thttpClient.get<any>(_url).subscribe({
${tabs}\t	next: () => { fail(\'should have failed with the 404 error\'); },
${tabs}\t	error: (error: HttpErrorResponse) => {
${tabs}\t		expect(error.status).withContext(\'status\').toEqual(404);
${tabs}\t		expect(error.error).withContext(\'message\').toEqual(_msg);
${tabs}\t		expect(error).toEqual(error);
${tabs}\t	}
${tabs}\t});
${tabs}\t// Assert
${tabs}\tconst testRequest = httpTestingController.expectOne(_url);
${tabs}\texpect(testRequest.request.method).toEqual(\'GET\');
${tabs}\ttestRequest.flush(_msg, _data);
${tabs}});
${tabs}
${tabs}it(\'#should set errorMessage and error if http.get returns an error\', () => {
${tabs}\t// Arrange
${tabs}\tconst _url: string = "/${GenValues.string().toLowerCase()}";
${tabs}\tconst _error = \'deliberate 404 error\';
${tabs}\tconst _data: any = { error: _error, status: 404, statusText: "Not Found" };
${tabs}\tconst _spy = spyOn(httpClient, \'get\').and.returnValue(throwError(() => _data));
${tabs}\t// Act (should call the tested function itself)
${tabs}\tcomponent.onSubmit(_url);
${tabs}\t// Assert
${tabs}\texpect(_spy).toHaveBeenCalledOnceWith(_url);
${tabs}\t// expect(component.errorMessage).toEqual(\'{"error":"deliberate 404 error","status":404,"statusText":"Not Found"}\');
${tabs}\t// expect(component.error).toEqual(_error);
${tabs}});

${tabs}

${tabs}
${tabs}/*
${tabs}// dummy test to write a quick test (!!)
${tabs}it(\'#should test "${sub.name}" with call "${sub.call}"\', () => {
${tabs}\t// Arrange
${tabs}\t// Act
${tabs}\t// Assert
${tabs}});
${tabs}*/;
${tabs}
${tabs}/*
${haxe.Json.stringify(sub, null, '  ')}
${tabs}*/
${tabs}
${tabs}\n';

		// ${tabs}it(\'#should spy on "${sub.name}" call "${sub.call}" and return dummy data\', () => {
		// ${tabs}\t// Arrange
		// ${tabs}\tconst _IValue: IValue = SPEC_CONST.getValue(IValue);
		// ${tabs}\t// command click on "${sub.call.name}()" to see what value it will return
		// ${tabs}\t${sub.name}Client.${sub.call.name}.and.returnValue(of(_IValue));
		// ${tabs}\t// Act
		// ${tabs}\t// service.help = _IValue;
		// ${tabs}\t// service.ngOnInit();
		// ${tabs}\t// Assert
		// ${tabs}\t// expect(component.help).toBe(_IValue);
		// ${tabs}});
		// ${tabs}it(\'should set "${sub.name}" errorMessage and error if http.get returns an error\', () => {
		// ${tabs}\t// Arrange
		// ${tabs}\tconst _url: string = "/test";
		// ${tabs}\tconst _errorMessage = \'deliberate 404 error\';
		// ${tabs}\tconst _error: any = { error: _errorMessage, status: 404, statusText: "Not Found" };
		// ${tabs}\t${sub.name}Client.${sub.call.name}.and.returnValue(throwError(() => _error));
		// ${tabs}\t// Act
		// ${tabs}\t// service.ngOnInit();
		// ${tabs}\t// Assert
		// ${tabs}\texpect(${sub.name}Client.${sub.call.name}).toHaveBeenCalled();
		// ${tabs}\texpect(notificationService.error).toHaveBeenCalled();
		// ${tabs}});
		// ${tabs}

		// ${tabs}it(\'should set "${sub.name}" errorMessage and error if http.get returns an error and calls notificationService\', () => {
		// ${tabs}\t// Arrange
		// ${tabs}\tconst _errorMessage = "Er is een fout opgetreden bij het ophalen van het online help document.";
		// ${tabs}\tconst _error: any = { error: _errorMessage, status: 404, statusText: "Not Found" };
		// ${tabs}\tconst _HttpErrorResponse: HttpErrorResponse = {
		// ${tabs}\t\tname: \'HttpErrorResponse\',
		// ${tabs}\t\tmessage: "",
		// ${tabs}\t\terror: _error,
		// ${tabs}\t\tok: false,
		// ${tabs}\t\theaders: new HttpHeaders,
		// ${tabs}\t\tstatus: 0,
		// ${tabs}\t\tstatusText: "",
		// ${tabs}\t\turl: null,
		// ${tabs}\t\ttype: HttpEventType.ResponseHeader
		// ${tabs}\t};
		// ${tabs}\t${sub.name}Client.${sub.call.name}.and.returnValue(throwError(() => _HttpErrorResponse));
		// ${tabs}\t// Act
		// ${tabs}\t// service.ngOnInit();
		// ${tabs}\t// Assert
		// ${tabs}\texpect(notificationServiceSpy.error).toHaveBeenCalledWith(_errorMessage);
		// ${tabs}});
		// ${tabs}\n';

		return out;
	}
}
