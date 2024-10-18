// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/pages/home.dart';

void main() {
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
