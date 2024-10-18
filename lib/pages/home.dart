import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/theme.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello World Page'),
        backgroundColor: ThemeColors().appBarColor,
      ),
      body: const Center(
        child: Text(
          'Hello, World!',
        ),
      ),
    );
  }
}
