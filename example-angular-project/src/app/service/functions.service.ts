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

	// ____________________________________ params ____________________________________

	funcOneParam(test: string) {

	}

	funcTwoParam(test: string, param: boolean) {

	}

	funcThreeParam(test: string, param: boolean, foo: number) {

	}

	funcFourParam(test: string, param: boolean, foo: number, array: string[]) {

	}

	// ____________________________________ basics ____________________________________

	funcOneStringParam(test: string) {

	}

	funcOneBooleanParam(test: boolean) {

	}

	funcOneNumberParam(test: number) {

	}

	funcOneAnyParam(test: any) {

	}

	// ____________________________________ interface ____________________________________

	funcOneIHelpParam(test: IHelp) {

	}

	// ____________________________________ array ____________________________________

	funcOneArrayStringParam(test: string[]) {

	}

	funcOneArrayBooleanParam(test: boolean[]) {

	}

	funcOneArrayNumberParam(test: number[]) {

	}

	funcOneArrayIHelpParam(test: IHelp[]) {

	}
}
