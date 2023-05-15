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

import { ObservablesService } from './observables.service';

// import directly from observablesService
import { IHelp } from '../shared/interfaces/i-help';
import { Api } from '../shared/config/api';

fdescribe('ObservablesService (Generated)', () => {

	let service: ObservablesService;
	let observablesService: ObservablesService; // [mck] might be removed in the future


	let httpMock: HttpTestingController;


	beforeEach(() => {
		TestBed.configureTestingModule({
			imports: [HttpClientTestingModule],
			providers: [ObservablesService]
		});
		service = TestBed.inject(ObservablesService);
		observablesService = TestBed.inject(ObservablesService); // [mck] might be removed in the future

		httpMock = TestBed.inject(HttpTestingController);
	});

	afterEach(() => {
		httpMock.verify();
	});

	it('should be created', () => {
		expect(service).toBeTruthy();
	});

	// 1. Generated test function "getData"
	// Test with return type `Observable`
	it('#getData should return Observable<IHelp>', (done: DoneFn) => {

		// Arrange
		

		// FIXME: add (all) missing properties 
		const ihelp: IHelp = {};
		

		// URL used in class
		const url = Api.getUrl().helpApi;

		// Act
		// create the service call
		service.getData().subscribe(value => {
			expect(value).toBe(ihelp);
			done();
		});

		// Assert
		const mockReq = httpMock.expectOne(url);
		expect(mockReq.request.url).toBe(url);
		expect(mockReq.request.method).toBe("GET");
		expect(mockReq.cancelled).toBeFalsy();
		expect(mockReq.request.responseType).toEqual('json');
		mockReq.flush(ihelp);
	});

});
