import 'package:apptodo1/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apptodo1/blocs/bloc_exports.dart';
import 'package:apptodo1/screens/recycle_bin.dart';
import 'package:apptodo1/screens/tabs_screen.dart';

class MyDrawer extends StatefulWidget {
   MyDrawer({Key? key}):super(key:key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> logout() async {
    await auth.signOut().then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
            (route) => false));
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()),(route) => true);
  }


  _logout() async{
    await auth.signOut();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              color: Colors.grey,
              child: Text(
                'Task Drawer',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(TabsScreen.id),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tasks')
                        .where('iduser',isEqualTo: auth.currentUser!.uid)
                        .snapshots(),
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> postSnapshot) {
                      final postDocs = postSnapshot.data!.docs;
                      return ListTile(
                        leading: const Icon(Icons.folder_special),
                        title: const Text('My Tasks'),
                        trailing: Text('${postDocs.length} | ${state.completedTasks.length}'),//Text('${state.pendingTasks.length} | ${state.completedTasks.length}')
                      );
                    },

                  ),
                );
              },
            ),
            const Divider(),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(RecycleBin.id),
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Bin'),
                    trailing: Text('${state.removedTasks.length}'),
                  ),
                );
              },
            ),
            const Divider(),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: (){
                      logout();
                  },
                    // context.read<AuthenticationBloc>().mapEventToState(event!),
                  child:const ListTile(
                    leading:  Icon(Icons.logout),
                    title:  Text('Logout'),
                  ),
                );
              },
            ),
            const Divider(),
            BlocBuilder<SwitchBloc, SwitchState>(builder: (context, state) {
              return Switch(
                  value: state.switchValue,
                  onChanged: (newValue) {
                    newValue
                        ? context.read<SwitchBloc>().add(SwitchOnEvent())
                        : context.read<SwitchBloc>().add(SwitchOffEvent());
                  });
            }),
          ],
        ),
      ),
    );
  }
}
