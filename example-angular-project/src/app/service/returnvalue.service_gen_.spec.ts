/*
- WARNING: this is a generated test. 
- Most likely you need to change and update this file. 
- Generated on: 2023-05-15
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
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnAny(): any {
	 *		return 1;
	 *	}
	 */
	xit('#returnAny should return any', () => {
		
		const result: any = service.returnAny();
		// expect(result).toBe(1);
		// expect(result).toBe(true);
		expect(service.returnAny).toBeDefined();
	});

	// 11. Generated test for "returnAnyParam"
	// Test with return type `any` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnAnyParam(value: any): any {
	 *		return 1;
	 *	}
	 */
	xit('#returnAnyParam should return any', () => {
		const value: any = {};
		const result: any = service.returnAnyParam(value);
		// expect(result).toBe(1);
		// expect(result).toBe(true);
		expect(service.returnAnyParam).toBeDefined();
	});

	// 12. Generated test for "returnIHelp"
	// Test with return type `IHelp` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnIHelp(): IHelp {
	 *		const iHelp: IHelp = {
	 *			url: 'x'
	 *		}
	 *		return iHelp;
	 *	}
	 */
	xit('#returnIHelp should return IHelp', () => {
		
		const result: IHelp = service.returnIHelp();
		// expect(result).toBe(iHelp);
		// expect(result).toBe(true);
		expect(service.returnIHelp).toBeDefined();
	});

	// 13. Generated test for "returnIHelpParam"
	// Test with return type `IHelp` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnIHelpParam(value: IHelp): IHelp {
	 *		const iHelp: IHelp = {
	 *			url: 'x'
	 *		}
	 *		return iHelp;
	 *	}
	 */
	xit('#returnIHelpParam should return IHelp', () => {
		const value: IHelp = {
			url: ''
		};
		const result: IHelp = service.returnIHelpParam(value);
		// expect(result).toBe(iHelp);
		// expect(result).toBe(true);
		expect(service.returnIHelpParam).toBeDefined();
	});

	// 14. Generated test for "returnArrayString"
	// Test with return type `string[]` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnArrayString(): string[] {
	 *		return ["string", "string"];
	 *	}
	 */
	xit('#returnArrayString should return string[]', () => {
		
		const result: string[] = service.returnArrayString();
		// expect(result).toBe(["string", "string"]);
		// expect(result).toBe(true);
		expect(service.returnArrayString).toBeDefined();
	});

	// 15. Generated test for "returnArrayBoolean"
	// Test with return type `boolean[]` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnArrayBoolean(): boolean[] {
	 *		return [true, false];
	 *	}
	 */
	xit('#returnArrayBoolean should return boolean[]', () => {
		
		const result: boolean[] = service.returnArrayBoolean();
		// expect(result).toBe([true, false]);
		// expect(result).toBe(true);
		expect(service.returnArrayBoolean).toBeDefined();
	});

	// 16. Generated test for "returnArrayNumber"
	// Test with return type `number[]` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnArrayNumber(): number[] {
	 *		return [1, 2];
	 *	}
	 */
	xit('#returnArrayNumber should return number[]', () => {
		
		const result: number[] = service.returnArrayNumber();
		// expect(result).toBe([1, 2]);
		// expect(result).toBe(true);
		expect(service.returnArrayNumber).toBeDefined();
	});

	// 17. Generated test for "returnBooleanNull"
	// Test with return type `boolean | null` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnBooleanNull(): boolean | null {
	 *		return true;
	 *	}
	 */
	xit('#returnBooleanNull should return boolean | null', () => {
		
		const result: boolean | null = service.returnBooleanNull();
		// expect(result).toBe(true);
		// expect(result).toBe(true);
		expect(service.returnBooleanNull).toBeDefined();
	});

	// 18. Generated test for "returnStringNumber"
	// Test with return type `string | number` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnStringNumber(): string | number {
	 *		return 1;
	 *	}
	 */
	xit('#returnStringNumber should return string | number', () => {
		
		const result: string | number = service.returnStringNumber();
		// expect(result).toBe(1);
		// expect(result).toBe(true);
		expect(service.returnStringNumber).toBeDefined();
	});

});
