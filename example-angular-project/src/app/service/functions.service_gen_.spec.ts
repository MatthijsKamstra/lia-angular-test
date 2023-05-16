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

	// 1. Generated test for "funcNoParam"
	it('#funcNoParam should return void', () => {

		const spy = spyOn(service, 'funcNoParam');
		const result = service.funcNoParam();
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcNoParam).toBeDefined();
	});

	// 2. Generated test for "funcOneParam"
	it('#funcOneParam should return void', () => {
		const pTest: string = "";

		const spy = spyOn(service, 'funcOneParam');
		const result = service.funcOneParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneParam).toBeDefined();
	});

	// 3. Generated test for "funcTwoParam"
	it('#funcTwoParam should return void', () => {
		const pTest: string = "";
		const pIsVisible: boolean = true;

		const spy = spyOn(service, 'funcTwoParam');
		const result = service.funcTwoParam(pTest, pIsVisible);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcTwoParam).toBeDefined();
	});

	// 4. Generated test for "funcThreeParam"
	it('#funcThreeParam should return void', () => {
		const pTest: string = "";
		const pIsVisible: boolean = true;
		const pCount: number = 0;

		const spy = spyOn(service, 'funcThreeParam');
		const result = service.funcThreeParam(pTest, pIsVisible, pCount);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcThreeParam).toBeDefined();
	});

	// 5. Generated test for "funcFourParam"
	it('#funcFourParam should return void', () => {
		const pTest: string = "";
		const pIsVisible: boolean = true;
		const pCount: number = 0;

		// FIXME: add (all) missing properties
		const pArray: string[] = [];
		// export const PARRAY: string[] = {}; // this var needs to be added to SPEC_CONST
		// const pArray: string[] = SPEC_CONST.getValue(PARRAY);


		const spy = spyOn(service, 'funcFourParam');
		const result = service.funcFourParam(pTest, pIsVisible, pCount, pArray);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcFourParam).toBeDefined();
	});

	// 6. Generated test for "funcOneStringParam"
	it('#funcOneStringParam should return void', () => {
		const pTest: string = "";

		const spy = spyOn(service, 'funcOneStringParam');
		const result = service.funcOneStringParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneStringParam).toBeDefined();
	});

	// 7. Generated test for "funcOneBooleanParam"
	it('#funcOneBooleanParam should return void', () => {
		const pTest: boolean = true;

		const spy = spyOn(service, 'funcOneBooleanParam');
		const result = service.funcOneBooleanParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneBooleanParam).toBeDefined();
	});

	// 8. Generated test for "funcOneNumberParam"
	it('#funcOneNumberParam should return void', () => {
		const pTest: number = 0;

		const spy = spyOn(service, 'funcOneNumberParam');
		const result = service.funcOneNumberParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneNumberParam).toBeDefined();
	});

	// 9. Generated test for "funcOneAnyParam"
	it('#funcOneAnyParam should return void', () => {
		const pTest: any = {};

		const spy = spyOn(service, 'funcOneAnyParam');
		const result = service.funcOneAnyParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneAnyParam).toBeDefined();
	});

	// 10. Generated test for "funcOneIHelpParam"
	it('#funcOneIHelpParam should return void', () => {
		const pTest: IHelp = {
			url: ''
		};

		const spy = spyOn(service, 'funcOneIHelpParam');
		const result = service.funcOneIHelpParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneIHelpParam).toBeDefined();
	});

	// 11. Generated test for "funcOneArrayStringParam"
	it('#funcOneArrayStringParam should return void', () => {

		// FIXME: add (all) missing properties
		const pTest: string[] = [];
		// export const PTEST: string[] = {}; // this var needs to be added to SPEC_CONST
		// const pTest: string[] = SPEC_CONST.getValue(PTEST);


		const spy = spyOn(service, 'funcOneArrayStringParam');
		const result = service.funcOneArrayStringParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneArrayStringParam).toBeDefined();
	});

	// 12. Generated test for "funcOneArrayBooleanParam"
	it('#funcOneArrayBooleanParam should return void', () => {

		// FIXME: add (all) missing properties
		const pTest: boolean[] = [];
		// export const PTEST: boolean[] = {}; // this var needs to be added to SPEC_CONST
		// const pTest: boolean[] = SPEC_CONST.getValue(PTEST);


		const spy = spyOn(service, 'funcOneArrayBooleanParam');
		const result = service.funcOneArrayBooleanParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneArrayBooleanParam).toBeDefined();
	});

	// 13. Generated test for "funcOneArrayNumberParam"
	it('#funcOneArrayNumberParam should return void', () => {

		// FIXME: add (all) missing properties
		const pTest: number[] = [];
		// export const PTEST: number[] = {}; // this var needs to be added to SPEC_CONST
		// const pTest: number[] = SPEC_CONST.getValue(PTEST);


		const spy = spyOn(service, 'funcOneArrayNumberParam');
		const result = service.funcOneArrayNumberParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneArrayNumberParam).toBeDefined();
	});

	// 14. Generated test for "funcOneArrayIHelpParam"
	it('#funcOneArrayIHelpParam should return void', () => {

		// FIXME: add (all) missing properties
		const pTest: IHelp[] = [];
		// export const PTEST: IHelp[] = {}; // this var needs to be added to SPEC_CONST
		// const pTest: IHelp[] = SPEC_CONST.getValue(PTEST);


		const spy = spyOn(service, 'funcOneArrayIHelpParam');
		const result = service.funcOneArrayIHelpParam(pTest);
		expect(result).toBeUndefined();
		expect(result).toBeFalsy();
		expect(spy).toHaveBeenCalled();
		expect(service.funcOneArrayIHelpParam).toBeDefined();
	});

});
