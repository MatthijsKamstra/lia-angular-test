import { Injectable } from '@angular/core';
import { IPagination } from '../shared/interfaces/i-pagination';
import { SortedByEnum } from '../shared/enums/sortedby.enum';
import { ISort } from '../shared/interfaces/i-sort';
import { SortDirectionEnum } from '../shared/enums/sortdirection.enum';

@Injectable({
	providedIn: 'root'
})
export class GetterSetterService {

	_pagination: IPagination = {
		totalItems: 0,
		pageNumber: 1,
		pageSize: 15
	};

	sort: ISort = {
		sortDir: SortDirectionEnum.ASC,
		sortedBy: SortedByEnum.CODE
	}

	constructor() { }

	public getPagination(): IPagination {
		return this._pagination;
	}

	public setPagination(pagination: IPagination): void {
		this._pagination = pagination;
	}

	public get pagination(): IPagination {
		return this._pagination;
	}

	public set pagination(pagination: IPagination) {
		this._pagination = pagination;
	}

	/**
	 * no public, return value Isort
	 */
	getSort(sortedBy: SortedByEnum = SortedByEnum.CODE): ISort {
		return this.sort;
	}

	/**
	 * no public, no return value
	 */
	setSort(sort: ISort) {
		this.sort = sort;
	}
}
