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

import { GetterSetterService } from './getter-setter.service';

// import directly from getter-setterService
import { IPagination } from '../shared/interfaces/i-pagination';

fdescribe('GetterSetterService (Generated)', () => {

	let service: GetterSetterService;
	let getterSetterService: GetterSetterService; // [mck] might be removed in the future


	let httpMock: HttpTestingController;


	beforeEach(() => {
		TestBed.configureTestingModule({
			imports: [HttpClientTestingModule],
			providers: [GetterSetterService]
		});
		service = TestBed.inject(GetterSetterService);
		getterSetterService = TestBed.inject(GetterSetterService); // [mck] might be removed in the future

		httpMock = TestBed.inject(HttpTestingController);
	});

	afterEach(() => {
		httpMock.verify();
	});

	it('should be created', () => {
		expect(service).toBeTruthy();
	});

	// 1. Generated test function "getPagination"
	// Test GETTER with return type `IPagination`
	/**
	 *	public getPagination(): IPagination {
	 *		return this._pagination;
	 *	}
	 */
	it('#getPagination should return IPagination', () => {
		
		const result: IPagination = service.getPagination();
		expect(result).toBe(service._pagination);
	});

	// 2. Generated test function "setPagination"
	// Test SETTER with return type `void`
	/**
	 *	public setPagination(pagination: IPagination): void {
	 *		this._pagination = pagination;
	 *	}
	 */
	it('#setPagination should return void', () => {
		// Arrange
		const pagination: IPagination = {
			totalItems: 0,
			pageNumber: 0,
			pageSize: 0
		};

		// Act
		service.setPagination(pagination);

		// Assert
		const result: IPagination = service.getPagination();
		expect(result).toBe(pagination);
	});

	// 3. Generated test function "get pagination"
	// Test GETTER with return type `IPagination`
	/**
	 *	public get pagination(): IPagination {
	 *		return this._pagination;
	 *	}
	 */
	it('#get pagination should return IPagination', () => {
		
		const result: IPagination = service.get pagination();
		expect(result).toBe(service._pagination);
	});

	// 4. Generated test function "set pagination"
	// Test SETTER with return type `void`
	/**
	 *	public set pagination(pagination: IPagination) {
	 *		this._pagination = pagination;
	 *	}
	 */
	it('#set pagination should return void', () => {
		// Arrange
		const pagination: IPagination = {
			totalItems: 0,
			pageNumber: 0,
			pageSize: 0
		};

		// Act
		service.set pagination(pagination);

		// Assert
		const result: IPagination = service.get pagination();
		expect(result).toBe(pagination);
	});

});
