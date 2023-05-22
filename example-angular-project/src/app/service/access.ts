// https://stackoverflow.com/questions/35987055/how-to-write-unit-testing-for-angular-typescript-for-private-methods-with-jasm

class MyThing {

	private _name: string;
	private _count: number;

	constructor() {
		this.init("Test", 123);
	}

	private init(name: string, count: number) {
		this._name = name;
		this._count = count;
	}

	public get name() { return this._name; }

	public get count() { return this._count; }

}
