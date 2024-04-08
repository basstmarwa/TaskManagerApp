import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/cash_manager.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/screens/tasks_screen.dart';
import 'package:task_manager_app/task_provider.dart';


Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = LoginScreen();

    return ChangeNotifierProvider<TaskProvider>(

      create: (context) => TaskProvider(),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 147, 229, 250),
            brightness: Brightness.dark,
            surface: const Color.fromARGB(255, 42, 51, 59),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
        ),
        home: Scaffold(
          body: content,
        ),
      ),
    );
  }
}
