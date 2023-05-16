/*
- WARNING: this is a generated test. 
- Most likely you need to change and update this file. 
- Generated on: 2023-05-16
- Version: 0.1.1
*/

/*
Copyright 2014-2023 Smart Society Services B.V.
*/


import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

import { ReturnvalueService } from './returnvalue.service';

// import directly from returnvalueService
import { ISort } from '../shared/interfaces/i-sort';
import { IHelp } from '../shared/interfaces/i-help';

fdescribe('ReturnvalueService (Generated)', () => {

	let service: ReturnvalueService;
	let returnvalueService: ReturnvalueService; // [mck] might be removed in the future


	let httpMock: HttpTestingController;


	beforeEach(() => {
		TestBed.configureTestingModule({
			imports: [HttpClientTestingModule],
			providers: [ReturnvalueService]
		});
		service = TestBed.inject(ReturnvalueService);
		returnvalueService = TestBed.inject(ReturnvalueService); // [mck] might be removed in the future

		httpMock = TestBed.inject(HttpTestingController);
	});

	afterEach(() => {
		httpMock.verify();
	});

	it('should be created', () => {
		expect(service).toBeTruthy();
	});

	// 1. Generated test for "returnVoid"
	it('#returnVoid should return void', () => {
		
		const spy = spyOn(service, 'returnVoid');
		const result = service.returnVoid();
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.returnVoid).toBeDefined();
	});

	// 2. Generated test for "returnNoVoid"
	it('#returnNoVoid should return void', () => {
		
		const spy = spyOn(service, 'returnNoVoid');
		const result = service.returnNoVoid();
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.returnNoVoid).toBeDefined();
	});

	// 3. Generated test for "returnBoolean"
	it('#returnBoolean should return boolean', () => {
		
		const spy = spyOn(service, 'returnBoolean').and.returnValue(true);
		const result: boolean = service.returnBoolean();
		expect(result).toBe(true);
		expect(result).toBeTruthy();
		expect(spy).toHaveBeenCalled();
		expect(service.returnBoolean()).toBeTruthy();
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.returnBoolean()).toBeTrue();
		expect(spy).toHaveBeenCalledTimes(3);
		expect(service.returnBoolean).toBeDefined();
	});

	// 4. Generated test for "returnBooleanParam"
	it('#returnBooleanParam should return boolean', () => {
		const value: boolean = true;
		
		const spy = spyOn(service, 'returnBooleanParam').and.returnValue(true);
		const result: boolean = service.returnBooleanParam(value);
		expect(result).toBe(true);
		expect(result).toBeTruthy();
		expect(spy).toHaveBeenCalled();
		expect(service.returnBooleanParam(value)).toBeTruthy();
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.returnBooleanParam(value)).toBeTrue();
		expect(spy).toHaveBeenCalledTimes(3);
		expect(service.returnBooleanParam).toBeDefined();
	});

	// 5. Generated test for "returnString"
	it('#returnString should return string', () => {
		
		const str = 'foo';
		const spy = spyOn(service, 'returnString').and.returnValue('foo');
		const result: string = service.returnString();
		expect(result).toBe('foo');
		expect(spy).toHaveBeenCalled();
		expect(service.returnString()).toBe('foo');
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.returnString()).toContain('foo');
		expect(spy).toHaveBeenCalledTimes(3);
		expect(service.returnString()).toBe(str);
		expect(spy).toHaveBeenCalledTimes(4);
		expect(service.returnString).toBeDefined();
	});

	// 6. Generated test for "returnString2"
	it('#returnString2 should return string', () => {
		
		const str = service._string;
		const spy = spyOn(service, 'returnString2').and.returnValue(service._string);
		const result: string = service.returnString2();
		expect(result).toBe(service._string);
		expect(spy).toHaveBeenCalled();
		expect(service.returnString2()).toBe(service._string);
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.returnString2()).toContain(service._string);
		expect(spy).toHaveBeenCalledTimes(3);
		expect(service.returnString2()).toBe(str);
		expect(spy).toHaveBeenCalledTimes(4);
		expect(service.returnString2).toBeDefined();
	});

	// 7. Generated test for "returnStringParam"
	it('#returnStringParam should return string', () => {
		const value: string = "";
		
		const str = "foobar";
		const spy = spyOn(service, 'returnStringParam').and.returnValue("foobar");
		const result: string = service.returnStringParam(value);
		expect(result).toBe("foobar");
		expect(spy).toHaveBeenCalled();
		expect(service.returnStringParam(value)).toBe("foobar");
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.returnStringParam(value)).toContain("foobar");
		expect(spy).toHaveBeenCalledTimes(3);
		expect(service.returnStringParam(value)).toBe(str);
		expect(spy).toHaveBeenCalledTimes(4);
		expect(service.returnStringParam).toBeDefined();
	});

	// 8. Generated test for "returnNumber"
	it('#returnNumber should return number', () => {
		
		const spy = spyOn(service, 'returnNumber').and.returnValue(1);
		const result: number = service.returnNumber();
		expect(result).toBe(1);
		expect(spy).toHaveBeenCalled();
		expect(service.returnNumber()).toBeTruthy();
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.returnNumber).toBeDefined();
	});

	// 9. Generated test for "returnNumberParam"
	it('#returnNumberParam should return number', () => {
		const value: number = 0;
		
		const spy = spyOn(service, 'returnNumberParam').and.returnValue(1);
		const result: number = service.returnNumberParam(value);
		expect(result).toBe(1);
		expect(spy).toHaveBeenCalled();
		expect(service.returnNumberParam(value)).toBeTruthy();
		expect(spy).toHaveBeenCalledTimes(2);
		expect(service.returnNumberParam).toBeDefined();
	});

	// 10. Generated test for "returnAny"
	// Test with return type `any` (UNKNOWN)
	/**
	 *	returnAny(): any {
	 *		return 1;
	 *	}
	 */
	it('#returnAny should return any', () => {
		
		// const spy = spyOn(service, 'returnAny').and.returnValue(1);
		const result: any = service.returnAny();
		expect(service.returnAny).toBeDefined();
		// expect(spy).toHaveBeenCalled();
	});

	// 11. Generated test for "returnAnyParam"
	// Test with return type `any` (UNKNOWN)
	/**
	 *	returnAnyParam(value: any): any {
	 *		return 1;
	 *	}
	 */
	it('#returnAnyParam should return any', () => {
		const value: any = {};
		
		// const spy = spyOn(service, 'returnAnyParam').and.returnValue(1);
		const result: any = service.returnAnyParam(value);
		expect(service.returnAnyParam).toBeDefined();
		// expect(spy).toHaveBeenCalled();
	});

	// 12. Generated test for "returnArrayString"
	it('#returnArrayString should return string[]', () => {
		
		const arr: string[] = ["string", "string"];
		const spy = spyOn(service, 'returnArrayString').and.returnValue(arr);
		const result: string[] = service.returnArrayString();
		expect(result).toEqual(arr);
		expect(service.returnArrayString).toBeDefined();
		expect(spy).toHaveBeenCalled();
	});

	// 13. Generated test for "returnArrayBoolean"
	it('#returnArrayBoolean should return boolean[]', () => {
		
		const arr: boolean[] = [true, false];
		const spy = spyOn(service, 'returnArrayBoolean').and.returnValue(arr);
		const result: boolean[] = service.returnArrayBoolean();
		expect(result).toEqual(arr);
		expect(service.returnArrayBoolean).toBeDefined();
		expect(spy).toHaveBeenCalled();
	});

	// 14. Generated test for "returnArrayNumber"
	it('#returnArrayNumber should return number[]', () => {
		
		const arr: number[] = [1, 2];
		const spy = spyOn(service, 'returnArrayNumber').and.returnValue(arr);
		const result: number[] = service.returnArrayNumber();
		expect(result).toEqual(arr);
		expect(service.returnArrayNumber).toBeDefined();
		expect(spy).toHaveBeenCalled();
	});

	// 15. Generated test for "returnArrayIhelp"
	it('#returnArrayIhelp should return IHelp[]', () => {
		
		const arr: IHelp[] = []; // [ihelp0, ihelp1] // TODO add vars;
		const spy = spyOn(service, 'returnArrayIhelp').and.returnValue(arr);
		const result: IHelp[] = service.returnArrayIhelp();
		expect(result).toEqual(arr);
		expect(service.returnArrayIhelp).toBeDefined();
		expect(spy).toHaveBeenCalled();
	});

	// 16. Generated test for "returnIHelp"
	// Test with return type `IHelp` (UNKNOWN)
	/**
	 *	returnIHelp(): IHelp {
	 *		const iHelp: IHelp = {
	 *			url: 'x'
	 *		}
	 *		return iHelp;
	 *	}
	 */
	it('#returnIHelp should return IHelp', () => {
		
		// const spy = spyOn(service, 'returnIHelp').and.returnValue(iHelp);
		const result: IHelp = service.returnIHelp();
		expect(service.returnIHelp).toBeDefined();
		// expect(spy).toHaveBeenCalled();
	});

	// 17. Generated test for "returnIHelpParam"
	// Test with return type `IHelp` (UNKNOWN)
	/**
	 *	returnIHelpParam(value: IHelp): IHelp {
	 *		const iHelp: IHelp = {
	 *			url: 'x'
	 *		}
	 *		return iHelp;
	 *	}
	 */
	it('#returnIHelpParam should return IHelp', () => {
		const value: IHelp = {
			url: ''
		};
		
		// const spy = spyOn(service, 'returnIHelpParam').and.returnValue(iHelp);
		const result: IHelp = service.returnIHelpParam(value);
		expect(service.returnIHelpParam).toBeDefined();
		// expect(spy).toHaveBeenCalled();
	});

	// 18. Generated test for "returnBooleanNull"
	// Test with return type `boolean | null` (UNKNOWN)
	/**
	 *	returnBooleanNull(): boolean | null {
	 *		return true;
	 *	}
	 */
	it('#returnBooleanNull should return boolean | null', () => {
		
		// const spy = spyOn(service, 'returnBooleanNull').and.returnValue(true);
		const result: boolean | null = service.returnBooleanNull();
		expect(service.returnBooleanNull).toBeDefined();
		// expect(spy).toHaveBeenCalled();
	});

	// 19. Generated test for "returnStringNumber"
	// Test with return type `string | number` (UNKNOWN)
	/**
	 *	returnStringNumber(): string | number {
	 *		return 1;
	 *	}
	 */
	it('#returnStringNumber should return string | number', () => {
		
		// const spy = spyOn(service, 'returnStringNumber').and.returnValue(1);
		const result: string | number = service.returnStringNumber();
		expect(service.returnStringNumber).toBeDefined();
		// expect(spy).toHaveBeenCalled();
	});

});
