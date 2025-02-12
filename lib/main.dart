import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:notes/core/services/hive_service.dart';
import 'package:notes/src/presentation/pages/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  await HiveService.addDefaultCategory();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Lufga'),
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          elevation: 0,
        ),
      ),
      home: Dashboard(),
    );
  }
}
