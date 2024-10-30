import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field.dart';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final email = emailKey.currentState?.textValue;
    final password = passwordKey.currentState?.textValue;
    final Map<String, String> translatedMessages ={
      'User or password incorrect':'Datos incorrectos',
      'Email don\'t confirmed': 'Email no confirmado',
      'User don\'t activated': 'Email no activado',
      'User deleted': 'Usuario eliminado'
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://eventify.allsites.es/public/api/login'), //cambiar a url de api
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },

        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      print(email);
      print(password);
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Manejar respuesta exitosa
        
        print('Login exitoso: $data');
        Navigator.pushNamed(context, '/login');

        // Aquí puedes navegar a otra pantalla o almacenar la sesión
      } else {
        // Manejar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${translatedMessages[data['data']['error']]}')),
          
        );
        
        print(response.body);
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
                        //routeName: '/login',
                        buttonText: 'Iniciar Sesión',
                        onPressed: () async {
                          await login();
                        },
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
                  )
                )
            ],
          ),
        ),
      ),
    );
  }
}
