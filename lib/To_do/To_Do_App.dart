import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:to_do_app_hive_local_storage/Custom_Widget/Custom_Widget.dart";
import "package:to_do_app_hive_local_storage/To_do/Util/dialog_box.dart";
import "package:to_do_app_hive_local_storage/To_do/Util/todo_title.dart";
import "package:to_do_app_hive_local_storage/To_do/data/database.dart";

void main() async {
  /// init the hive
  await Hive.initFlutter();

  /// open a box
  var box = await Hive.openBox("mybox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "To Do App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
          centerTitle: true,
        ),
      ),
      home: const ToDoApplication(),
    );
  }
}

class ToDoApplication extends StatefulWidget {
  const ToDoApplication({super.key});

  @override
  State<ToDoApplication> createState() {
    return ToDoApplicationState();
  }
}

class ToDoApplicationState extends State<ToDoApplication> {
  /// reference the hive box
  final _myBox = Hive.box("mybox");

  final _controller = TextEditingController();

  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    /// if this is the 1st time ever opening the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      /// there already exists data
      db.loadData();
    }
    super.initState();
  }

  /// checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(
      () {
        db.toDoList[index][1] = !db.toDoList[index][1];
      },
    );
    db.updateDatabase();
  }

  /// Save new Task
  void saveNewTask() {
    setState(
      () {
        db.toDoList.add([_controller.text, false]);
        _controller.clear();
      },
    );
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  /// Create a New Task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  /// delete Task
  void deleteTask(int index) {
    setState(
      () {
        db.toDoList.removeAt(index);
      },
    );
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.customAppBar("To Do App"),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) {
              return checkBoxChanged(value, index);
            },
            deleteFunction: (context) {
              return deleteTask(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white, size: 30.0),
      ),
    );
  }
}
