import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apptodo1/services/guid_gen.dart';

import '../blocs/tasks_bloc/tasks_bloc.dart';
import '../models/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskLocalStorage {
  static const String _key = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = tasks.map((task) => task.toMap()).toList();
    await prefs.setString(_key, json.encode(taskList));
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(_key);

    if (tasksJson != null) {
      final List<dynamic> tasksList = json.decode(tasksJson);
      return tasksList.map((taskJson) => Task.fromMap(taskJson)).toList();
    } else {
      return [];
    }
  }
}

class AddTaskScreen extends StatelessWidget {
  //final Function(Task) onAddTask;
   AddTaskScreen({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;


    return Container(
      padding:const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Add Task',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10),
            child: TextField(
              autofocus: true,
              controller: titleController,
              decoration:const InputDecoration(
                label: Text('Title'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextField(
            autofocus: true,
            controller: descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration:const InputDecoration(
              label: Text('Description'),
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:const Text('cancel'),
              ),
              ElevatedButton(
                  onPressed: () {
                    var task =Task(
                        iduser: _auth.currentUser!.uid,
                        title: titleController.text,
                        description: descriptionController.text,
                        status: '',//tasks.status
                        id: GUIDGen.generate(),
                        date: DateTime.now().toString()
                    );
                    BlocProvider.of<TasksBloc>(context).add(AddTask(task: task));
                    //context.read<TasksBloc>().add(AddTask(task: task));
                    Navigator.pop(context);
                  },
                  child: const Text('Add')
              )
            ],
          ),
        ],
      ),
    );
  }
}