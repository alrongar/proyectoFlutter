import 'package:eventify_flutter/config/theme/app_theme.dart';
import 'package:eventify_flutter/presentation/screens/login/register_screen.dart';
import 'package:eventify_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify_flutter/presentation/screens/login/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eventify',
        theme: AppTheme(selectedColor: 1).theme(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) =>
              const RegisterScreen(), 
        });
  }
}
