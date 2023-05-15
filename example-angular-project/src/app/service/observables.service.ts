import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IHelp } from '../shared/interfaces/i-help';
import { Api } from '../shared/config/api';

@Injectable({
	providedIn: 'root'
})
export class ObservablesService {

	constructor(private http: HttpClient) { }

	getData(): Observable<IHelp> {
		const url = Api.getUrl().helpApi;
		return this.http.get<IHelp>(url);
	}
}
