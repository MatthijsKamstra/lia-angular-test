package utils;

class Todo {
	static public function bullitList(arr:Array<String>) {}

	static public function todoList(arr:Array<String>) {}

	static public function split(arr:Array<Array<String>>):TodoObject {
		var obj:TodoObject = {
			totalArr: [],
			doneArr: [],
			todoArr: [], // Array<String>;
			total: 0, // Int;
			done: 0, // Int;
			todo: 0, // Int;
		};
		for (i in 0...arr.length) {
			var todoArr = arr[i];
			// trace(todoArr);
			for (j in 0...todoArr.length) {
				var todo = todoArr[j];
				obj.totalArr.push(todo);
				if (todo.indexOf('[x]') != -1) {
					obj.doneArr.push(todo);
				} else {
					obj.todoArr.push(todo);
				}
				obj.total = obj.totalArr.length;
				obj.todo = obj.todoArr.length;
				obj.done = obj.doneArr.length;
				// trace(todo);
			}
		}
		return obj;
	}
}

typedef TodoObject = {
	var totalArr:Array<String>;
	var doneArr:Array<String>;
	var todoArr:Array<String>;
	var total:Int;
	var done:Int;
	var todo:Int;
}
