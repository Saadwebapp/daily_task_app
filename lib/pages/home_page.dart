// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp_codesoft/components/dialog_box.dart';
import 'package:todoapp_codesoft/components/task_container.dart';
import 'package:todoapp_codesoft/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mybox = Hive.box("mybox");
  //text controllers
  final _titlecontroller = TextEditingController();
  final _desccontroller = TextEditingController();
  int tasksRemaining = 0;
  ToDoDataBase db = ToDoDataBase();
  List<String> priorityList = <String>[
    'Low',
    'Medium',
    'High',
  ];
  String dropdownValue = 'Low'; // Define dropdownValue here
  @override
  void initState() {
    db.loadData();
    tasksRemaining = db.toDoList.length;
    // TODO: implement initState
    super.initState();
  }

  //checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      // Update the completion status of the task
      bool taskCompleted = db.toDoList[index][2];
      db.toDoList[index][2] = value ?? false;

      // Adjust the tasksRemaining count based on the change in completion status
      if (taskCompleted != (value ?? false)) {
        if (value == true) {
          // If the task is checked (completed), decrement tasksRemaining
          tasksRemaining--;
        } else {
          // If the task is unchecked (not completed), increment tasksRemaining
          tasksRemaining++;
        }
      }
    });

    // Update the database after the state change
    db.updateDatabase();
  }
  //save new task

  void saveNewTask() {
    setState(() {
      db.toDoList.add([
        _titlecontroller.text,
        _desccontroller.text,
        false,
        dropdownValue, // Set the completion status to false
      ]);
      tasksRemaining++;
      Navigator.of(context).pop();
      _desccontroller.clear();
      _titlecontroller.clear();
      // dropdownValue.clear();
      db.updateDatabase();
    });
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          descController: _desccontroller,
          titleController: _titlecontroller,
          onCancel: () {
            Navigator.pop(context);
          },
          onSave: saveNewTask,
          items: priorityList,
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          value: dropdownValue,
          onPrioritySelected: (priority) {
            setState(() {
              dropdownValue = priority;
            });
          },
        );
      },
    );
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      bool taskCompleted = db.toDoList[index][2];
      db.toDoList.removeAt(index);
      if (taskCompleted == true) {
        tasksRemaining; // Only reduce remaining tasks if the task was completed
      } else {
        tasksRemaining--;
      }
    });
    db.updateDatabase();
  }

  //update task
  void updateTask(int index) {
    final titleControler = TextEditingController(text: db.toDoList[index][0]);
    final descController = TextEditingController(text: db.toDoList[index][1]);
    final dropdownValue = db.toDoList[index][3];

    showDialog(
      context: context,
      builder: (context) {
        String dropdownValue = priorityList.first;
        return DialogBox(
          titleController: titleControler,
          descController: descController,
          onSave: () {
            setState(() {
              // Access title and description from the controllers passed to DialogBox
              db.toDoList[index][0] = titleControler.text;
              db.toDoList[index][1] = descController.text;
              db.toDoList[index][3] = dropdownValue;
              db.updateDatabase();
            });
            print(db.toDoList);
            Navigator.pop(context);
          },
          onCancel: () {
            Navigator.pop(context);
          },
          items: priorityList,
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          value: dropdownValue,
          onPrioritySelected: (priority) {
            dropdownValue = priority;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[400],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Center(child: Text("TODO")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(
          Icons.add,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15.0,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Saad",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Gap(5),
              Text(
                "$tasksRemaining tasks remaining",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              Gap(20),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        BorderSide(color: Colors.deepPurple), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                        color: Colors.deepPurple), // Border color when focused
                  ),
                  hintText: 'Search...',
                  hintStyle:
                      TextStyle(fontSize: 16.0, color: Colors.deepPurple[400]),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.deepPurple[400],
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
              ),
              Gap(20),
              Expanded(
                child: ListView.builder(
                  itemCount: db.toDoList.length,
                  itemBuilder: (context, index) {
                    print(db.toDoList);
                    return ToDoTasks(
                      onChanged: (value) => checkBoxChanged(value, index),
                      taskName: db.toDoList[index][0],
                      taskDescription: db.toDoList[index][1],
                      taskCompleted: db.toDoList[index][2],
                      deleteFunction: (context) => deleteTask(index),
                      updateFunction: (context) => updateTask(index),
                      priority: db.toDoList[index][3],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
