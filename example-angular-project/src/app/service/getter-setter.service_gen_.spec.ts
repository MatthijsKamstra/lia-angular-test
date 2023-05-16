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

import { GetterSetterService } from './getter-setter.service';

// import directly from getter-setterService
import { IPagination } from '../shared/interfaces/i-pagination';
import { SortedByEnum } from '../shared/enums/sortedby.enum';
import { ISort } from '../shared/interfaces/i-sort';
import { SortDirectionEnum } from '../shared/enums/sortdirection.enum';

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

	// 1. Generated test for "getPagination"
	// Test GETTER with return type `IPagination`
	/**
	 *	public getPagination(): IPagination {
	 *		return this._pagination;
	 *	}
	 */
	it('#getPagination should return IPagination', () => {
		
		const result: IPagination = service.getPagination();
		expect(result).toBe(service._pagination);
		expect(service.getPagination).toBeDefined();
	});

	// 2. Generated test for "setPagination"
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
		expect(service.setPagination).toBeDefined();
	});

	// 3. Generated test for "getSort"
	// Test GETTER with return type `ISort`
	/**
	 *	
	 *	getSort(sortedBy: SortedByEnum = SortedByEnum.CODE): ISort {
	 *		return this.sort;
	 *	}
	 */
	it('#getSort should return ISort', () => {
		
		// FIXME: add (all) missing properties 
		// const sortedBy: SortedByEnum = SortedByEnum.CODE = {};
		// export const SORTEDBY: SortedByEnum = SortedByEnum.CODE = {}; // this var needs to be added to SPEC_CONST
		const sortedBy: SortedByEnum = SortedByEnum.CODE = SPEC_CONST.getValue(SORTEDBY);
		
		
		const result: ISort = service.getSort(sortedBy);
		expect(result).toBe(service.sort);
		expect(service.getSort).toBeDefined();
	});

	// 4. Generated test for "setSort"
	// Test SETTER with return type `void`
	/**
	 *	
	 *	setSort(sort: ISort) {
	 *		this.sort = sort;
	 *	}
	 */
	it('#setSort should return void', () => {
		// Arrange
		const sort: ISort = {
			sortDir: SortDirectionEnum.ASC,
			sortedBy: SortedByEnum.CODE
		};
		

		// Act
		service.setSort(sort);

		// Assert
		const result: ISort = service.getSort();
		expect(result).toBe(sort);
		expect(service.setSort).toBeDefined();
	});

});
