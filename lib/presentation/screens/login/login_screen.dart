import 'dart:convert';
import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field.dart';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:eventify_flutter/providers/event_service.dart';
import 'package:eventify_flutter/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/rutes/app_routes.dart'; // Importar las rutas

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<CustomTextFieldState> emailKey =
      GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> passwordKey =
      GlobalKey<CustomTextFieldState>();

  Future<void> login() async {
    final email = emailKey.currentState?.textValue ?? '';
    final password = passwordKey.currentState?.textValue ?? '';
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    } else {
      try {
        final response = await http.post(
          Uri.parse('https://eventify.allsites.es/public/api/login'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode({'email': email, 'password': password}),
        );

        final data = jsonDecode(response.body);
        print(data);
        if (response.statusCode == 200) {
          final token = data['data']['token'];
          final userId =
              data['data']['id']; // Suponiendo que el id del usuario está aquí
          final role = data['data']['role'];
          print(role == 'o');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString(
              'user_id', userId.toString()); // Guardar el id del usuario
          await prefs.setString('role', role);
          if (email.isNotEmpty) {
            await prefs.setString('email', email);
          }
          if (role == 'o') {
            EventServices eventServices = new EventServices();
            Map<String, int> registeredData = await eventServices.fetchRegisteredCountByMonth();
            String stringRegisteredData = jsonEncode(registeredData);
            await prefs.setString('stringRegisteredData', stringRegisteredData);
          }

          if (!mounted) return;

          Navigator.pushNamed(context, AppRoutes.home, arguments: email);
        } else {
          var errorMessage = UserService.getTranslatedMessage(data);
          if (errorMessage == 'Error desconocido') {
            errorMessage = 'Error en el inicio de sesión';
          }
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en el inicio de sesión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      title: '',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/Eventify_logo.png',
                  width: 230,
                  height: 230,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20), // Espaciado ajustado
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      key: emailKey,
                      hintTextContent: 'Correo Electrónico',
                      isRequired: true,
                      regularExpression:
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      key: passwordKey,
                      hintTextContent: 'Contraseña',
                      isPassword: true,
                      isRequired: true,
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      buttonText: 'Iniciar Sesión',
                      onPressed: () async {
                        await login();
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: const Text(
                        '¿No tienes una cuenta? Regístrate aquí',
                        style: TextStyle(
                          fontSize: 15.0, // Tamaño de texto ajustado
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
