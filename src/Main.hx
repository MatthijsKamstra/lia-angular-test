import haxe.io.Path;
import sys.io.Process;

using StringTools;

class Main {
	/**
	 * 0.0.1 	initial release
	 */
	var VERSION:String = '0.0.1';

	var ROOT:String = '';

	var dirCount = 0;
	var fileCount = 0;

	var fileArr:Array<String> = [];
	var dirArr:Array<String> = [];

	var startTime:Date;
	var endTime:Date;

	public function new(?args:Array<String>) {
		// Sys.command('clear'); // will produce a `TERM environment variable not set.`
		info('Start project: "${Project.NAME}"');
		// check time
		startTime = Date.now();

		initArgs(args);

		if (ROOT == '')
			return;

		// initLog();
		// init();
		// setupProject();
		recursiveLoop(ROOT);

		info('dirCount: $dirCount', 1);
		info('fileCount: $fileCount', 1);
		// info('ignoreArr: $ignoreArr', 1);

		// do something clever

		// check time again
		endTime = Date.now();
		warn('Time to complete conversion: ${((endTime.getTime() - startTime.getTime()) / 1000)} sec');
	}

	function initArgs(?args:Array<String>) {
		var args:Array<String> = args;

		if (args.length == 0)
			args.push('-h');

		for (i in 0...args.length) {
			var temp = args[i];
			switch (temp) {
				case '-v', '-version':
					Sys.println('version: ' + VERSION);
				case '-cd', '-folder': // isFolderSet = true;
				case '-help', '-h':
					showHelp();
				case '-out', '-o':
					// log(args[i + 1]);
					writeOut();
				case '-in', '-i':
					log('root path: "${args[i + 1]}"');
					ROOT = args[i + 1];
				default:
					// trace("case '" + temp + "': trace ('" + temp + "');");
			}
		}
	}

	function writeOut() {
		var str = '# README\n\n**Generated on:** ${Date.now()}\n**Target:**';
		writeFile(Sys.getCwd(), 'TESTME.MD', str);
	}

	/**
	 * simply write the files
	 * @param path 		folder to write the files (current assumption is `EXPORT`)
	 * @param filename	(with extension) the file name
	 * @param content	what to write to the file (in our case markdown)
	 */
	function writeFile(path:String, filename:String, content:String) {
		if (!sys.FileSystem.exists(path)) {
			sys.FileSystem.createDirectory(path);
		}
		// write the file
		sys.io.File.saveContent(path + '/${filename}', content);
		trace('written file: ${path}/${filename}');
	}

	// function init() {
	// 	Folder.ROOT_FOLDER = Sys.getCwd();
	// 	Folder.BIN = Path.join([Sys.getCwd(), 'bin']);
	// 	Folder.DIST = Path.join([Sys.getCwd(), 'dist']);
	// 	Folder.ASSETS = Path.join([Sys.getCwd(), 'assets']);
	// 	// info('Folder.ROOT_FOLDER: ${Folder.ROOT_FOLDER}');
	// 	// info(Folder.BIN);
	// 	// info(Folder.DIST);
	// 	// info('Folder.ASSETS: ${Folder.ASSETS}');
	// }

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

	function showHelp():Void {
		Sys.println('------------------------------------------------
Lia-angular-test ($VERSION)

	-version / -v   : version number
	-help / -h      : show this help
	-in / -i	    : path to project folder
	-out / -o       : write readme (WIP)
------------------------------------------------
');

	}

	static public function main() {
		var app = new Main(Sys.args());
	}
}
