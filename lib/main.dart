import 'package:f1_flutter/theme/theme.dart';
import 'package:f1_flutter/views/wrapper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      title: 'F1 Mobile',
      home: const Home(),
    );
  }
}
