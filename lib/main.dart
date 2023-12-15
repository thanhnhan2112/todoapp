import 'package:apptodo1/blocs/bloc_exports.dart';
import 'package:apptodo1/models/tasks.dart';
import 'package:apptodo1/screens/add_task_screen.dart';

import 'package:apptodo1/screens/login_screen.dart';
import 'package:apptodo1/screens/tabs_screen.dart';
import 'package:apptodo1/services/app_router.dart';
import 'package:apptodo1/services/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  List<Task> tasks = await TaskLocalStorage.loadTasks();
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.appRouter}) : super(key: key);
  final AppRouter appRouter;
  //firebase_auth.FirebaseAuth firebaseAuth=firebase_auth.FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TasksBloc(),
        ),
        BlocProvider(
          create: (context) => SwitchBloc(),
        ),
      ],
      // ..add(AddTask(task: Task(title: 'Task1'))
      child: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Tasks App',
            theme: state.switchValue
                ? AppThemes.appThemeData[AppTheme.darkTheme]
                : AppThemes.appThemeData[AppTheme.lightTheme],
            initialRoute: Login.id,
            routes: {
              TabsScreen.id:(context)=>const TabsScreen(),
              Login.id:(context)=>const Login(),
            },
            onGenerateRoute: appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}

