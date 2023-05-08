package const;

class Config {
	/**
	 * 0.0.1 - initial code
	 * 0.0.2 - setup code reading, overwrite, etc
	 * 0.0.3 - POC services
	 * 0.0.4 - services update
	 * 0.0.5 - service typedef update, POST and GET, multiple functions, data in test needed
	 * 0.0.6 - test based upon return types (bool, string, etc)
	 *
	 */
	public static final VERSION:String = '0.0.6';

	public static var PATH = ''; // file or folder
	public static var IS_OVERWRITE = false;
	public static var IS_DRYRUN = false;
}
