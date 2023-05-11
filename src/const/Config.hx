package const;

class Config {
	/**
	 * 0.0.1 - initial code
	 * 0.0.2 - setup code reading, overwrite, etc
	 * 0.0.3 - POC services
	 * 0.0.4 - services update
	 * 0.0.5 - service typedef update, POST and GET, multiple functions, data in test needed
	 * 0.0.6 - test based upon return types (bool, string, etc)
	 * 0.0.7 - fix bug from bigger classes
	 * 0.0.8 - remove time from generation, getter setter tests, default var values added
	 * 0.0.9 - add extra constructor values as variables and TestBed
	 * 0.1.0 - fix bug in getter tests to add params
	 */
	public static final VERSION:String = '0.1.0';

	public static var PATH = ''; // file or folder
	public static var IS_OVERWRITE = false;
	public static var IS_DRYRUN = false;
}
