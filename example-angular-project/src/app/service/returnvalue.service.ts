import { Injectable } from '@angular/core';
import { ISort } from '../shared/interfaces/i-sort';
import { IHelp } from '../shared/interfaces/i-help';

@Injectable({
	providedIn: 'root'
})
export class ReturnvalueService {

	constructor() { }

	// ____________________________________ void ____________________________________

	returnVoid(): void {
		// console.log('void');
	}

	returnNoVoid() {
		// console.log('no void');
	}

	// ____________________________________ bool, string, array, number ____________________________________

	returnBoolean(): boolean {
		console.warn('set boolean true');
		return true;
	}

	returnBooleanParam(value: boolean): boolean {
		console.warn('set boolean true');
		return true;
	}

	returnString(): string {
		return 'foo';
	}

	_string = 'foo2';

	returnString2(): string {
		return this._string;
	}

	returnStringParam(value: string): string {
		return "foobar";
	}

	returnNumber(): number {
		return 1;
	}

	returnNumberParam(value: number): number {
		return 1;
	}

	returnAny(): any {
		return 1;
	}

	returnAnyParam(value: any): any {
		return 1;
	}



	// ____________________________________ array ____________________________________

	returnArrayString(): string[] {
		return ["string", "string"];
	}

	returnArrayBoolean(): boolean[] {
		return [true, false];
	}

	returnArrayNumber(): number[] {
		return [1, 2];
	}

	returnArrayIhelp(): IHelp[] {
		const ihelp0: IHelp = { url: '' }
		const ihelp1: IHelp = { url: '' }
		return [ihelp0, ihelp1];
	}

	// ____________________________________ interface ____________________________________

	returnIHelp(): IHelp {
		const iHelp: IHelp = {
			url: 'x'
		}
		return iHelp;
	}

	returnIHelpParam(value: IHelp): IHelp {
		const iHelp: IHelp = {
			url: 'x'
		}
		return iHelp;
	}

	// ____________________________________ union types ____________________________________

	returnBooleanNull(): boolean | null {
		return true;
	}

	returnStringNumber(): string | number {
		return 1;
	}

}
