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
		info('search and replace curly brackets for import');
		var _reg = RegEx.importCurlyBrackets;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('  ', ' ').replace('\r', '');
				warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('DONE search and replace curly brackets for import');

		info('search and replace curly brackets for object');
		var _reg = RegEx.objectCurlyBrackets;
		var matches = RegEx.getMatches(_reg, content);
		log('total: ' + matches.length);
		if (matches.length > 0) {
			// log(matches);
			for (i in 0...matches.length) {
				var match = matches[i];
				// warn(match, 2, Yellow);
				var clean = match.replace('\n', '').replace('\t', '').replace('__________', '').replace('    ', ' ').replace('  ', ' ').replace('\r', '');
				warn(clean, 1);
				content = content.replace(match, clean);
			}
		}
		info('DONE search and replace curly brackets for object');

		return content;
	}
}
