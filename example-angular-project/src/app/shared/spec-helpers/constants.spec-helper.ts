import { IHelp } from "../interfaces/i-help"


export const IHELP: IHelp = {
	url: ""
}

export const PTEST: IHelp[] = [IHELP];

/**
 * @example
 *
 * ```ts
 * const ihelp:IHelp = SPEC_CONST.getValue(IHELP);
 * ```
 *
 */
export const SPEC_CONST = {
	/**
	 * create a copy of the const
	 *
	 * @param val
	 * @returns
	 */
	getValue(val: any) {
		return Object.assign({}, val);
	}
}
