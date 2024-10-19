// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/pages/home.dart';
import 'package:sharp_shooter_pro/services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required for async operations in main
  await SharedPreferencesService().init(); // Initialize SharedPreferences

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
