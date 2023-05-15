import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IHelp } from '../shared/interfaces/i-help';
import { Api } from '../shared/config/api';

@Injectable({
	providedIn: 'root'
})
export class FunctionsService {

	constructor(private http: HttpClient) { }

	funcNoParam() {

	}

	funcOneStringParam(test: string) {

	}

	funcOneBooleanParam(test: boolean) {

	}

	funcOneNumberParam(test: number) {

	}
}
