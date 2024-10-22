import 'package:eventify_flutter/config/theme/app_theme.dart';
import 'package:eventify_flutter/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 1).theme(),
      title: 'Eventify',
      home: const LoginScreen(),
    );
  }
}