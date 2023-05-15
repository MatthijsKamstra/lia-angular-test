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

	// 1. Generated test function "returnBoolean"
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

	// 2. Generated test function "returnString"
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

	// 3. Generated test function "returnArrayString"
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

	// 4. Generated test function "returnNumber"
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

	// 5. Generated test function "returnBooleanNull"
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

	// 6. Generated test function "returnVoid"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	returnVoid(): void {
	 *		console.log('void');
	 */
	xit('#returnVoid should return void', () => {
		
		service.returnVoid();
		// expect(result).toBe(true);
	});

	// 7. Generated test function "returnNoVoid"
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

});
