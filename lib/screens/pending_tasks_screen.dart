import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apptodo1/blocs/bloc_exports.dart';

import '../models/tasks.dart';
import '../widgets/task_tile.dart';
import '../widgets/tasks_list.dart';

class PendingTasksScreen extends StatefulWidget {
  const PendingTasksScreen({super.key});

  @override
  State<PendingTasksScreen> createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getRequest() async {
    await _firestore
        .collection('tasks')
        .where('iduser', isEqualTo: _auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequest();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      List<Task> tasksList = state.pendingTasks;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Center(
            //   child: Chip(
            //     label: Text(
            //       '${tasksList.length} Pending | ${state.completedTasks.length} Completed',
            //     ),
            //   ),
            // ),
            //TasksList(taskList: tasksList),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .where('iduser', isEqualTo: _auth.currentUser!.uid)
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> postSnapshot) {
                  if (postSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final postDocs = postSnapshot.data!.docs;
                  return ListView.builder(
                    addAutomaticKeepAlives: true,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: PostCard(postDocs[index]));
                    },
                    itemCount: postDocs.length,
                  );
                }),
          ],
        ),
      );
    });
  }
}

// class PendingTasksScreen extends StatelessWidget {
//   const PendingTasksScreen({Key? key}) : super(key: key);
//   static const id = 'tasks_screen';
//
//
//   @override
//   Widget build(BuildContext context) {
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//
//     return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
//       List<Task> tasksList = state.pendingTasks;
//       return SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Center(
//             //   child: Chip(
//             //     label: Text(
//             //       '${tasksList.length} Pending | ${state.completedTasks.length} Completed',
//             //     ),
//             //   ),
//             // ),
//             // TasksList(taskList: tasksList)
//             StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('tasks')
//                     .where('iduser',isEqualTo: _auth.currentUser!.uid)
//                     .orderBy(
//                   'date',
//                   descending: true,
//                 )
//                     .snapshots(),
//                 builder: (ctx, AsyncSnapshot<QuerySnapshot> postSnapshot) {
//                   if (postSnapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   final postDocs = postSnapshot.data!.docs;
//                   return ListView.builder(
//                     addAutomaticKeepAlives: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return Container(
//                           margin: EdgeInsets.only(left: 10,right: 10,top: 10),
//                           child: PostCard(postDocs[index]));
//                     },
//                     itemCount: postDocs.length,
//                   );
//                 }),
//           ],
//         ),
//       );
//     });
//   }
// }

class PostCard extends StatefulWidget {
  static const id = 'tasks_screen';
  PostCard(this.post);
  final post;
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        title: SelectableText.rich(TextSpan(children: [
          const TextSpan(
            text: 'Text\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: widget.post.data()['title']),
          const TextSpan(
            text: '\n\nDescription\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: widget.post.data()['description']),
        ])),
      ),
    );
  }
}
