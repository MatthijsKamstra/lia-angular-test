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

	funcOneParam(pTest: string) {

	}

	funcTwoParam(pTest: string, pIsVisible: boolean) {

	}

	funcThreeParam(pTest: string, pIsVisible: boolean, pCount: number) {

	}

	funcFourParam(pTest: string, pIsVisible: boolean, pCount: number, pArray: string[]) {

	}

	// ____________________________________ basics ____________________________________

	funcOneStringParam(pTest: string) {

	}

	funcOneBooleanParam(pTest: boolean) {

	}

	funcOneNumberParam(pTest: number) {

	}

	funcOneAnyParam(pTest: any) {

	}

	// ____________________________________ interface ____________________________________

	funcOneIHelpParam(pTest: IHelp) {

	}

	// ____________________________________ array ____________________________________

	funcOneArrayStringParam(pTest: string[]) {

	}

	funcOneArrayBooleanParam(pTest: boolean[]) {

	}

	funcOneArrayNumberParam(pTest: number[]) {

	}

	funcOneArrayIHelpParam(pTest: IHelp[]) {

	}
}
