import { Injectable } from '@angular/core';
import { IPagination } from '../shared/interfaces/i-pagination';

@Injectable({
	providedIn: 'root'
})
export class GetterSetterService {

	_pagination: IPagination = {
		totalItems: 0,
		pageNumber: 1,
		pageSize: 15
	};

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
}
