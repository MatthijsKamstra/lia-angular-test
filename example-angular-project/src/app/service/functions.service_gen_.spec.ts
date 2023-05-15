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

import { FunctionsService } from './functions.service';

// import directly from functionsService
import { IHelp } from '../shared/interfaces/i-help';
import { Api } from '../shared/config/api';

fdescribe('FunctionsService (Generated)', () => {

	let service: FunctionsService;
	let functionsService: FunctionsService; // [mck] might be removed in the future


	let httpMock: HttpTestingController;


	beforeEach(() => {
		TestBed.configureTestingModule({
			imports: [HttpClientTestingModule],
			providers: [FunctionsService]
		});
		service = TestBed.inject(FunctionsService);
		functionsService = TestBed.inject(FunctionsService); // [mck] might be removed in the future

		httpMock = TestBed.inject(HttpTestingController);
	});

	afterEach(() => {
		httpMock.verify();
	});

	it('should be created', () => {
		expect(service).toBeTruthy();
	});

	// 1. Generated test function "funcNoParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcNoParam() {
	 */
	xit('#funcNoParam should return void', () => {
		
		service.funcNoParam();
		// expect(result).toBe(true);
	});

	// 2. Generated test function "funcOneStringParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneStringParam(test: string) {
	 */
	xit('#funcOneStringParam should return void', () => {
		const test: string = "";
		
		service.funcOneStringParam(test);
		// expect(result).toBe(true);
	});

	// 3. Generated test function "funcOneBooleanParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneBooleanParam(test: boolean) {
	 */
	xit('#funcOneBooleanParam should return void', () => {
		// FIXME: add (all) missing properties 
		const test: boolean = {};
		
		service.funcOneBooleanParam(test);
		// expect(result).toBe(true);
	});

	// 4. Generated test function "funcOneNumberParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneNumberParam(test: number) {
	 */
	xit('#funcOneNumberParam should return void', () => {
		const test: number = 0;
		
		service.funcOneNumberParam(test);
		// expect(result).toBe(true);
	});

});
