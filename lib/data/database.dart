import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];
// // Initialize Hive box for priorities
// Box<List<String>> priorityBox = Hive.box<List<String>>('priorityBox');

// // Add priorities list to Hive box
// void addPrioritiesList(List<String> priorities) {
//   priorityBox.put('priorities', priorities);
// }
  //reference our box
  final _mybox = Hive.box("mybox");

  //load data from database
  void loadData() {
    final List<dynamic>? dataList = _mybox.get("TODOLIST");
    if (dataList != null) {
      toDoList = List.from(dataList);
    } else {
      toDoList = []; // Assign an empty list if data is null
    }
  }

  //update the db
  void updateDatabase() {
    _mybox.put("TODOLIST", toDoList);
  }
}
