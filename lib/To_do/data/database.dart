import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  /// reference our box
  final _myBox = Hive.box("mybox");

  /// Run this method if this is the 1st time ever opening this app
  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false],
      ["Do Exercise", false],
    ];
  }

  /// Load the data from database
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  /// Update the database
  void updateDatabase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
