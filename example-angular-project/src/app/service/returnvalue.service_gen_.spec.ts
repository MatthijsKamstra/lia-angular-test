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

	// 1. Generated test function "returnVoid"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnVoid(): void {
	 *		console.log('void');
	 *	}
	 */
	xit('#returnVoid should return void', () => {
		
		service.returnVoid();
		// expect(result).toBe(true);
	});

	// 2. Generated test function "returnNoVoid"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnNoVoid() {
	 *		console.log('no void');
	 *	}
	 */
	xit('#returnNoVoid should return void', () => {
		
		service.returnNoVoid();
		// expect(result).toBe(true);
	});

	// 3. Generated test function "returnBoolean"
	/**
	 *	returnBoolean(): boolean {
	 *		return true;
	 *	}
	 */
	it('#returnBoolean should return boolean', () => {
		const result: boolean = service.returnBoolean();
		expect(result).toBe(true);
		// expect(result).toBe(true);
	});

	// 4. Generated test function "returnString"
	// Test with return type `string`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnString(): string {
	 *		return "string";
	 *	}
	 */
	xit('#returnString should return string', () => {
		const result: string = service.returnString();
		expect(result).toBe("string");
		// expect(result).toBe(true);
	});

	// 5. Generated test function "returnNumber"
	// Test with return type `number` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnNumber(): number {
	 *		return 1;
	 *	}
	 */
	xit('#returnNumber should return number', () => {
		const result: number = service.returnNumber();
		expect(result).toBe(1);
		// expect(result).toBe(true);
	});

	// 6. Generated test function "returnAny"
	// Test with return type `any` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnAny(): any {
	 *		return 1;
	 *	}
	 */
	xit('#returnAny should return any', () => {
		const result: any = service.returnAny();
		expect(result).toBe(1);
		// expect(result).toBe(true);
	});

	// 7. Generated test function "returnIHelp"
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
		expect(result).toBe(iHelp);
		// expect(result).toBe(true);
	});

	// 8. Generated test function "returnArrayString"
	// Test with return type `string[]` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnArrayString(): string[] {
	 *		return ["string", "string"];
	 *	}
	 */
	xit('#returnArrayString should return string[]', () => {
		const result: string[] = service.returnArrayString();
		expect(result).toBe(["string", "string"]);
		// expect(result).toBe(true);
	});

	// 9. Generated test function "returnArrayBoolean"
	// Test with return type `boolean[]` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnArrayBoolean(): boolean[] {
	 *		return [true, false];
	 *	}
	 */
	xit('#returnArrayBoolean should return boolean[]', () => {
		const result: boolean[] = service.returnArrayBoolean();
		expect(result).toBe([true, false]);
		// expect(result).toBe(true);
	});

	// 10. Generated test function "returnArrayNumber"
	// Test with return type `number[]` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnArrayNumber(): number[] {
	 *		return [1, 2];
	 *	}
	 *	returnArrayIhelp(): IHelp[] {
	 *		const ihelp0: IHelp = { url: '' }
	 *		const ihelp1: IHelp = { url: '' }
	 *		return [ihelp0, ihelp1];
	 *	}
	 */
	xit('#returnArrayNumber should return number[]', () => {
		const result: number[] = service.returnArrayNumber();
		expect(result).toBe([1, 2]);
		// expect(result).toBe(true);
	});

	// 11. Generated test function "returnBooleanNull"
	// Test with return type `boolean | null` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnBooleanNull(): boolean | null {
	 *		return true;
	 *	}
	 */
	xit('#returnBooleanNull should return boolean | null', () => {
		const result: boolean | null = service.returnBooleanNull();
		expect(result).toBe(true);
		// expect(result).toBe(true);
	});

	// 12. Generated test function "returnStringNumber"
	// Test with return type `string | number` (UNKNOWN)
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnStringNumber(): string | number {
	 *		return 1;
	 *	}
	 */
	xit('#returnStringNumber should return string | number', () => {
		const result: string | number = service.returnStringNumber();
		expect(result).toBe(1);
		// expect(result).toBe(true);
	});

});
