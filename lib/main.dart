import 'package:eventify_flutter/firebase_options.dart';
import 'package:eventify_flutter/presentation/screens/events/event_screen.dart';
import 'package:eventify_flutter/presentation/screens/login/login_screen.dart';
import 'package:eventify_flutter/presentation/screens/login/register_screen.dart';
import 'package:eventify_flutter/presentation/screens/users/admin_user_screen.dart';
import 'package:eventify_flutter/presentation/screens/events/create_event_screen.dart';
import 'package:eventify_flutter/presentation/screens/events/edit_event_screen.dart';
import 'package:eventify_flutter/presentation/screens/report/report_screen.dart';
import 'package:eventify_flutter/presentation/widgets/base_screen.dart';
import 'package:eventify_flutter/providers/firebase_api.dart';
import 'package:eventify_flutter/providers/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';

final navigatorkey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserService()),
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
      navigatorKey: navigatorkey,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/admin': (context) => const UserListScreen(),
        '/home': (context) {
          final email = ModalRoute.of(context)?.settings.arguments as String?;
          return BaseScreen(email: email ?? '');
        },
        '/eventos': (context) => EventosScreen(),
        '/report': (context) {
          final email = ModalRoute.of(context)?.settings.arguments as String?;
          return ReportScreen(email: email ?? '');
        },
        '/createEvent': (context) => CreateEventScreen(), // Añade la ruta para crear eventos
        '/editEvent': (context) => EditEventScreen(), // Añade la ruta para editar eventos
      },
    );
  }
}
