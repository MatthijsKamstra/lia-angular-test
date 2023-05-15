import { Injectable } from '@angular/core';

@Injectable({
	providedIn: 'root'
})
export class ReturnvalueService {

	constructor() { }

	returnBoolean(): boolean {
		return true;
	}

	returnString(): string {
		return "string";
	}

	returnArrayString(): string[] {
		return ["string", "string"];
	}

	returnNumber(): number {
		return 1;
	}

	returnBooleanNull(): boolean | null {
		return true;
	}

	returnVoid(): void {
		console.log('void');

	}

	returnNoVoid() {
		console.log('no void');
	}
}
