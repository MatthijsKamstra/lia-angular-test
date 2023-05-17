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

import { SPEC_CONST } from '../shared/spec-helpers/constants.spec-helper';

import { SplitService } from './split.service';

// import directly from splitService

fdescribe('SplitService (Generated)', () => {

	let service: SplitService;
	let splitService: SplitService; // [mck] might be removed in the future


	let httpMock: HttpTestingController;


	beforeEach(() => {
		TestBed.configureTestingModule({
			imports: [HttpClientTestingModule],
			providers: [SplitService]
		});
		service = TestBed.inject(SplitService);
		splitService = TestBed.inject(SplitService); // [mck] might be removed in the future

		httpMock = TestBed.inject(HttpTestingController);
	});

	afterEach(() => {
		httpMock.verify();
	});

	it('should be created', () => {
		expect(service).toBeTruthy();
	});

	// 1. Generated test for "functionIfElse"
	/**
	 *	functionIfElse(isVisible: boolean) {
	 *		if (isVisible) {
	 *			console.log('isVisible = true');
	 *		} else {
	 *			console.log('isVisible = false');
	 *		}
	 *	}
	 */
	it('#functionIfElse should return void', () => {
		const isVisible: boolean = true;
		
		const spy = spyOn(service, 'functionIfElse');
		const result = service.functionIfElse(isVisible);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.functionIfElse).toBeDefined();
	});

	// 2. Generated test for "func1"
	/**
	 *	func1() { }
	 */
	it('#func1 should return void', () => {
		
		const spy = spyOn(service, 'func1');
		const result = service.func1();
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.func1).toBeDefined();
	});

	// 3. Generated test for "functionCatch"
	/**
	 *	functionCatch() {
	 *		try {
	 *			console.log('try')
	 *			
	 *		} catch (error) {
	 *			console.error(error);
	 *			
	 *			
	 *		}
	 */
	it('#functionCatch should return void', () => {
		
		const spy = spyOn(service, 'functionCatch');
		const result = service.functionCatch();
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.functionCatch).toBeDefined();
	});

	// 4. Generated test for "func2"
	/**
	 *	func2() { }
	 */
	it('#func2 should return void', () => {
		
		const spy = spyOn(service, 'func2');
		const result = service.func2();
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.func2).toBeDefined();
	});

	// 5. Generated test for "func3"
	/**
	 *	func3() { }
	 */
	it('#func3 should return void', () => {
		
		const spy = spyOn(service, 'func3');
		const result = service.func3();
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.func3).toBeDefined();
	});

	// 6. Generated test for "func4"
	/**
	 *	func4() { }
	 */
	it('#func4 should return void', () => {
		
		const spy = spyOn(service, 'func4');
		const result = service.func4();
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.func4).toBeDefined();
	});

	// 7. Generated test for "func5"
	/**
	 *	func5() { }
	 */
	it('#func5 should return void', () => {
		
		const spy = spyOn(service, 'func5');
		const result = service.func5();
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.func5).toBeDefined();
	});

});
