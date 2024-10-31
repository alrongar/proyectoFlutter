import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field.dart';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
        title: '',
        child: SingleChildScrollView( // Asegúrate de envolver en un SingleChildScrollView
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image(
                    image: AssetImage('assets/Eventify_logo.png'),
                    width: 230,
                    height: 230,
                    fit: BoxFit.contain,
                  ),
                ),
                RegisterElements(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterElements extends StatefulWidget {
  const RegisterElements({super.key});

  @override
  RegisterElementsState createState() => RegisterElementsState();
}

class RegisterElementsState extends State<RegisterElements> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<CustomTextFieldState> emailKey = GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> passwordKey = GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> nameKey = GlobalKey<CustomTextFieldState>();
  String? errorMessage;
  String selectedUserType = 'u'; // Valor inicial

  Future<void> _registerUser() async {
    print("inicio del registro");
    if (formKey.currentState?.validate() ?? false) {
      final name = nameKey.currentState?.textValue;
      final email = emailKey.currentState?.textValue;
      final password = passwordKey.currentState?.textValue;
      final role = selectedUserType;
      if (name != null && email != null && password != null) {
        const String url = 'https://eventify.allsites.es/public/api/register'; // Cambiar por URL de la API

        try {
          final response = await http.post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'c_password': password,
              'role': role,
            }),
          );

          if (response.statusCode == 200) {
            print('Usuario registrado exitosamente');
            Navigator.pushNamed(context, '/login');
          } else {
            throw Exception('Error en el registro: ${response.body}');
          }
        } catch (e) {
          setState(() {
            errorMessage = 'Error al registrar el usuario: $e';
            print(errorMessage);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("pantalla de registro:");
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            key: nameKey,
            hintTextContent: 'Nombre',
            isRequired: true,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            key: emailKey,
            hintTextContent: 'Email',
            regularExpression: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          ),
          const SizedBox(height: 20),
          CustomTextField(
            key: passwordKey,
            hintTextContent: 'Contraseña',
            isPassword: true,
            isRequired: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRadio('u', 'Usuario'), // Mueve el estilo aquí
              _buildRadio('o', 'Organizador'), // Mueve el estilo aquí
            ],
          ),
          const SizedBox(height: 40),
          CustomButton(
            buttonText: 'Registrarse',
            onPressed: () async {
              await _registerUser();
            },
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              '¿Ya tienes una cuenta? Inicia sesión aquí',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Función para construir el botón de opción (radio button) con estilo
  Widget _buildRadio(String value, String label) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedUserType,
          onChanged: (String? newValue) {
            setState(() {
              selectedUserType = newValue!;
            });
          },
          activeColor: Colors.blue, // Cambiar color del radio button seleccionado
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white), // Cambiar color del texto
        ),
      ],
    );
  }
}
