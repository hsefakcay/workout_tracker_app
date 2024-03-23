import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker_app/data/workout_data.dart';
import 'package:workout_tracker_app/pages/home_page.dart';

Future<void> main() async {
  //initalize five
  await Hive.initFlutter();

  //open a hive  box
  await Hive.openBox("workout_database1");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                color: Color.fromARGB(255, 3, 2, 40),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
                iconTheme: IconThemeData(color: Colors.white)),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
