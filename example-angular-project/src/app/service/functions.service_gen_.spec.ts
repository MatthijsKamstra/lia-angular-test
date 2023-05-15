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

	// 2. Generated test function "funcOneParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneParam(test: string) {
	 */
	xit('#funcOneParam should return void', () => {
		const test: string = "";
		
		service.funcOneParam(test);
		// expect(result).toBe(true);
	});

	// 3. Generated test function "funcTwoParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcTwoParam(test: string, param: boolean) {
	 */
	xit('#funcTwoParam should return void', () => {
		const test: string = "";
		// FIXME: add (all) missing properties 
		const param: boolean = {};
		
		service.funcTwoParam(test, param);
		// expect(result).toBe(true);
	});

	// 4. Generated test function "funcThreeParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcThreeParam(test: string, param: boolean, foo: number) {
	 */
	xit('#funcThreeParam should return void', () => {
		const test: string = "";
		// FIXME: add (all) missing properties 
		const param: boolean = {};
		const foo: number = 0;
		
		service.funcThreeParam(test, param, foo);
		// expect(result).toBe(true);
	});

	// 5. Generated test function "funcFourParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcFourParam(test: string, param: boolean, foo: number, array: string[]) {
	 */
	xit('#funcFourParam should return void', () => {
		const test: string = "";
		// FIXME: add (all) missing properties 
		const param: boolean = {};
		const foo: number = 0;
		// FIXME: add (all) missing properties 
		const array: string[] = {};
		
		service.funcFourParam(test, param, foo, array);
		// expect(result).toBe(true);
	});

	// 6. Generated test function "funcOneStringParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	
	 *	funcOneStringParam(test: string) {
	 */
	xit('#funcOneStringParam should return void', () => {
		const test: string = "";
		
		service.funcOneStringParam(test);
		// expect(result).toBe(true);
	});

	// 7. Generated test function "funcOneBooleanParam"
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

	// 8. Generated test function "funcOneNumberParam"
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

	// 9. Generated test function "funcOneAnyParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneAnyParam(test: any) {
	 */
	xit('#funcOneAnyParam should return void', () => {
		const test: any = {};
		
		service.funcOneAnyParam(test);
		// expect(result).toBe(true);
	});

	// 10. Generated test function "funcOneIHelpParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneIHelpParam(test: IHelp) {
	 */
	xit('#funcOneIHelpParam should return void', () => {
		// FIXME: add (all) missing properties 
		const test: IHelp = {};
		
		service.funcOneIHelpParam(test);
		// expect(result).toBe(true);
	});

	// 11. Generated test function "funcOneArrayStringParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneArrayStringParam(test: string[]) {
	 */
	xit('#funcOneArrayStringParam should return void', () => {
		// FIXME: add (all) missing properties 
		const test: string[] = {};
		
		service.funcOneArrayStringParam(test);
		// expect(result).toBe(true);
	});

	// 12. Generated test function "funcOneArrayBooleanParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneArrayBooleanParam(test: boolean[]) {
	 */
	xit('#funcOneArrayBooleanParam should return void', () => {
		// FIXME: add (all) missing properties 
		const test: boolean[] = {};
		
		service.funcOneArrayBooleanParam(test);
		// expect(result).toBe(true);
	});

	// 13. Generated test function "funcOneArrayNumberParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneArrayNumberParam(test: number[]) {
	 */
	xit('#funcOneArrayNumberParam should return void', () => {
		// FIXME: add (all) missing properties 
		const test: number[] = {};
		
		service.funcOneArrayNumberParam(test);
		// expect(result).toBe(true);
	});

	// 14. Generated test function "funcOneArrayIHelpParam"
	// Test with return type `void`
	// [WIP] test is default disabled (`xit`) 
	/**
	 *	funcOneArrayIHelpParam(test: IHelp[]) {
	 */
	xit('#funcOneArrayIHelpParam should return void', () => {
		// FIXME: add (all) missing properties 
		const test: IHelp[] = {};
		
		service.funcOneArrayIHelpParam(test);
		// expect(result).toBe(true);
	});

});
