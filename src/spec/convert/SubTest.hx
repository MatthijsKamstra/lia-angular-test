package spec.convert;

import AST.SubScribeObj;

class SubTest {
	static public function create() {
		//
	}

	static public function components(sub:SubScribeObj, ?tabs:String = '\t'):String {
		var out = '\n';
		// it('#should spy "configSettingsService" ngOnInit with `IHelp` value', () => {
		out += '${tabs}it(\'#should spy on "${sub.name}" call "${sub.call}" and return dummy data\', () => {
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

${tabs}it(\'should set "${sub.name}" errorMessage and error if http.get returns an error\', () => {
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

${tabs}it(\'should set "${sub.name}" errorMessage and error if http.get returns an error and calls notificationService\', () => {
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

	static public function services(sub:SubScribeObj, ?tabs:String = '\t'):String {
		var out = '\n';
		// it('#should spy "configSettingsService" ngOnInit with `IHelp` value', () => {
		out += '${tabs}it(\'#should spy on "${sub.name}" call "${sub.call}" and return dummy data\', () => {
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

${tabs}it(\'should set "${sub.name}" errorMessage and error if http.get returns an error\', () => {
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

${tabs}it(\'should set "${sub.name}" errorMessage and error if http.get returns an error and calls notificationService\', () => {
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
}
