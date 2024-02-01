package remove;

import utils.RegEx;

using StringTools;

class RemoveStuff {
	static public function all(content:String, templateType:String):String {
		content = RemoveComment.all(content, templateType);

		// TODO
		// remove enters, spaces "  ", tabs, returns
		/**
			```ts
			import {
				IAsyncRequest,
				IDeviceORequest,
				IRequest,
				IRequestDevice,
			} from '../shared/interfaces/i-device-o-request';
			```

			and remove
			```ts
			defaultDevicesODataFilter: IDevicesODataFilter = {
				deviceIdentifications: '',
				type: DeviceOTypeEnum.ALL,
				manufacturer: '',
				devicemodel: '',
				activated: DeviceActivatedFilterType.ACTIVE,
				owner: '',
				moduleVersion: '',
				moduleType: '',
			};
			```

			```ts
			getFilteredDevices(
				filter: IDevicesODataFilter,
				pagination: IPagination
			): Observable<IPage<IDeviceO>> {
			```
		 */

		// {}
		info('[START] import - search and replace curly brackets');
		var _reg = RegEx.importCurlyBrackets;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length, 1);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('  ', ' ').replace('\r', '');
				// warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('[END] import - search and replace curly brackets');

		info('[START] object - search and replace curly brackets');
		var _reg = RegEx.objectCurlyBrackets;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length, 1);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('    ', ' ').replace('  ', ' ').replace('\r', '');
				// warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('[END] object - search and replace curly brackets');

		info('[START] return  - search and replace curly brackets');
		var _reg = RegEx.returnCurlyBrackets;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length, 1);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('    ', ' ').replace('  ', ' ').replace('\r', '');
				// warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('[END] return - search and replace curly brackets');

		info('[START] function()  - search and replace curly brackets');
		var _reg = RegEx.functionCurlyBrackets;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length, 1);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('    ', ' ').replace('  ', ' ').replace('\r', '');
				// warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('[END] function() - search and replace curly brackets');

		return content;
	}
}
