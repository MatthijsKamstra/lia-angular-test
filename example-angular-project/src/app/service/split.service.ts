import { Injectable } from '@angular/core';

@Injectable({
	providedIn: 'root'
})
export class SplitService {

	constructor() { }

	functionIfElse(isVisible: boolean) {
		if (isVisible) {
			console.log('isVisible = true');
		} else {
			console.log('isVisible = false');
		}
	}

	func1() { }

	functionCatch() {
		try {
			console.log('try')
			// nonExistentFunction();
		} catch (error) {
			console.error(error);
			// Expected output: ReferenceError: nonExistentFunction is not defined
			// (Note: the exact output may be browser-dependent)
		}

	}

	func2() { }

	func3() { }

	func4() { }

	func5() { }

}
