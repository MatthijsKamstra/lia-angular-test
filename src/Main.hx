import haxe.io.Path;
import sys.io.Process;

using StringTools;

class Main {
	var VERSION:String = '0.0.1';
	var ROOT:String = '';

	var fileArr:Array<String> = [];
	var dirArr:Array<String> = [];
	var ignoreArr:Array<String> = ['.gitkeep', '.buildignore', '.gitignore', '.DS_Store',];

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

		info('dirArr.length: ${dirArr.length}', 1);
		info('fileArr.length: ${fileArr.length}', 1);
		info('fileArr.length: ${fileArr.length / 4}', 1);
		info('ignoreArr: $ignoreArr', 1);

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
				case '-v', '--version':
					Sys.println('version: ' + VERSION);
				case '-cd', '--folder': // isFolderSet = true;
				case '-f', '--force': // isFolderSet = true;
				case '--help', '-h':
					showHelp();
				case '--out', '-o':
					// log(args[i + 1]);
					writeOut();
				case '--in', '-i':
					log('ROOT path: "${args[i + 1]}"');
					ROOT = args[i + 1];
				default:
					// trace("case '" + temp + "': trace ('" + temp + "');");
			}
		}
	}

	function writeOut() {
		var str = '# README\n\n**Generated on:** ${Date.now()}\n**Target:**';
		SaveFile.writeFile(Sys.getCwd(), 'TESTME.MD', str);
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
					var fileName = Path.withoutDirectory(path);
					// log(ignoreArr.contains(fileName));

					if (!ignoreArr.contains(fileName)) {
						// log(fileName);
						fileArr.push(path);
					} else {
						// log(fileName);
					}

					// log(Path.withoutDirectory(path));
					// ignoreArr.push(Path.withoutDirectory(path));
				} else {
					// folder
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
		Sys.println('
------------------------------------------------
Lia-angular-test ($VERSION)

  --version / -v	: version number
  --help / -h	: show this help
  --in / -i	: path to project folder
  --out / -o	: write readme (WIP)
  --force / -f	: force overwrite
------------------------------------------------
');

	}

	static public function main() {
		var app = new Main(Sys.args());
	}
}
