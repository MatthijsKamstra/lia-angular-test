class Main {
	var dirCount = 0;
	var fileCount = 0;

	var fileArr:Array<String> = [];
	var dirArr:Array<String> = [];

	var startTime:Date;
	var endTime:Date;

	public function new() {
		// Sys.command('clear'); // will produce a `TERM environment variable not set.`
		info('Start project: "${Project.NAME}"');
		// check time
		startTime = Date.now();

		initLog();
		init();
		// setupProject();
		createTree();
		recursiveLoop(Folder.SOURCE_FRONTEND);

		// info('dirCount: $dirCount', 1);
		// info('fileCount: $fileCount', 1);
		// info('ignoreArr: $ignoreArr', 1);

		// do something clever

		// check time again
		endTime = Date.now();
		warn('Time to complete conversion: ${((endTime.getTime() - startTime.getTime()) / 1000)} sec');
	}

	function init() {
		Folder.ROOT_FOLDER = Sys.getCwd();
		Folder.BIN = Path.join([Sys.getCwd(), 'bin']);
		Folder.DIST = Path.join([Sys.getCwd(), 'dist']);
		Folder.ASSETS = Path.join([Sys.getCwd(), 'assets']);
		// info('Folder.ROOT_FOLDER: ${Folder.ROOT_FOLDER}');
		// info(Folder.BIN);
		// info(Folder.DIST);
		// info('Folder.ASSETS: ${Folder.ASSETS}');
	}

	/**
	 * [Description]
	 * @param directory
	 */
	function recursiveLoop(directory:String = "path/to/") {
		if (sys.FileSystem.exists(directory)) {
			// log("Directory found: " + directory);
			for (file in sys.FileSystem.readDirectory(directory)) {
				var path = haxe.io.Path.join([directory, file]);
				if (!sys.FileSystem.isDirectory(path)) {
					// file
					// log("File found: " + path);
					fileCount++;
					fileArr.push(path);

					// log(Path.withoutDirectory(path));
					// ignoreArr.push(Path.withoutDirectory(path));
				} else {
					// folder
					dirCount++;
					dirArr.push(path);
					var directory = haxe.io.Path.addTrailingSlash(path);
					recursiveLoop(directory);
				}
			}
		} else {
			warn('${Emoji.x} "$directory" does not exists');
		}
	}

	/**
	 * quick and dirty export from install app called `tree`
	 */
	function createTree() {
		info('Create tree of: "${Project.NAME}"');
		Sys.command('cd', [Folder.SOURCE_FRONTEND]);
		Sys.command('tree > ${Folder.BIN}/tree.md');
	}

	/**
	 * test custom loggin
	 */
	function initLog() {
		Sys.println('this is the default sys.println');
		// logging via Haxe
		log("this is a log message");
		warn("this is a warn message");
		info("this is a info message");
		progress("this is a progress message");
	}

	static public function main() {
		var app = new Main();
	}
}
