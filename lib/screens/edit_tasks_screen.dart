import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/tasks_bloc/tasks_bloc.dart';
import '../models/tasks.dart';

@immutable
class EditTaskScreen extends StatelessWidget {
  final Task oldTask;
  const EditTaskScreen({Key? key, required this.oldTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController titleController =
    TextEditingController(text: oldTask.title);
    TextEditingController descriptionController =
    TextEditingController(text: oldTask.description);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Edit Task',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: TextField(
              autofocus: true,
              controller: titleController,
              decoration: const InputDecoration(
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
            decoration: const InputDecoration(
              label: Text('Description'),
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('cancel'),
              ),
              ElevatedButton(
                  onPressed: () {
                    var editedTask = Task(
                        iduser: _auth.currentUser!.uid,
                        title: titleController.text,
                        description: descriptionController.text,
                        status: toString(),
                        id: oldTask.id,
                        isFavorite: oldTask.isFavorite,
                        isDone: false,
                        date: DateTime.now().toString());
                    context
                        .read<TasksBloc>()
                        .add(EditTask(oldTask: oldTask, newTask: editedTask));
                    Navigator.pop(context);
                  },
                  child: const Text('Save'))
            ],
          ),
        ],
      ),
    );
  }
}
