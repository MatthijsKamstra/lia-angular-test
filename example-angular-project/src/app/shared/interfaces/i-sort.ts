import { SortDirectionEnum } from "../enums/sortdirection.enum";
import { SortedByEnum } from "../enums/sortedby.enum";

export type ISort = {
	sortDir: SortDirectionEnum,
	sortedBy: SortedByEnum,
}

