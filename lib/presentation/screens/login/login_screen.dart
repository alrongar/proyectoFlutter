import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field.dart';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    

    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('https://eventify.allsites.es/public/api/'),//cambiar a url de api
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Manejar respuesta exitosa
        final data = jsonDecode(response.body);
        print('Login exitoso: $data');
        // Aquí puedes navegar a otra pantalla o almacenar la sesión
      } else {
        // Manejar error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error en el inicio de sesión')),
      );
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
              // Logo en la parte superior
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/Eventify_logo.png',
                  width: 230,
                  height: 230,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                  height: 10), // Espaciado entre el logo y el formulario

              // Formulario de Login
              const CustomTextField(
                hintTextContent: 'Correo Electrónico',
                isRequired: true,
                regularExpression:
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              ),
              const SizedBox(height: 15),
              const CustomTextField(
                hintTextContent: 'Contraseña',
                isPassword: true,
                isRequired: true,
              ),
              const SizedBox(height: 40),
              CustomButton(
                routeName: '/login',
                buttonText: 'Iniciar Sesión',
                onPressed: login,
              ),
              const SizedBox(height: 20),

              // Link de registro
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  '¿No tienes una cuenta? Registrate sesión aquí',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
