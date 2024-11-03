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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image(
                    image: AssetImage('assets/Eventify_logo.png'),
                    width: 180,
                    height: 180,
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
  final GlobalKey<CustomTextFieldState> emailKey =
      GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> passwordKey =
      GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> cPasswordKey =
      GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> nameKey =
      GlobalKey<CustomTextFieldState>();

  String? errorMessage;
  String selectedUserType = 'u'; // Valor inicial

  Future<void> _registerUser() async {
    if (formKey.currentState?.validate() ?? false) {
      final name = nameKey.currentState?.textValue;
      final email = emailKey.currentState?.textValue;
      final password = passwordKey.currentState?.textValue;
      final cPassword = cPasswordKey.currentState?.textValue;
      final role = selectedUserType;
      if (name != null && email != null && password != null) {
        const String url = 'https://eventify.allsites.es/public/api/register';
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
              'c_password': cPassword,
              'role': role,
            }),
          );
          final data = jsonDecode(response.body);
          if (response.statusCode == 200) {
            if (!mounted) return;
            Navigator.pushNamed(context, '/login');
          } else {
            
            errorMessage = 'Error en el registro de usuario';
            if (data['exception'] == "Illuminate\\Database\\UniqueConstraintViolationException") {
              errorMessage = 'Email ya registrado';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage!)),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error en el registro de usuario')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            regularExpression:
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          ),
          const SizedBox(height: 20),
          CustomTextField(
            key: passwordKey,
            hintTextContent: 'Contraseña',
            isPassword: true,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            key: cPasswordKey,
            hintTextContent: 'Confirmar contraseña',
            isPassword: true,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRadio('u', 'Usuario'),
              _buildRadio('o', 'Organizador'),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            buttonText: 'Registrarse',
            onPressed: () async {
              String? textValue = cPasswordKey.currentState?.textValue;
              if (textValue != null &&
                  textValue != passwordKey.currentState?.textValue) {
                setState(() {
                  errorMessage = 'Las contraseñas no coinciden';
                });
                return;
              }
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
          activeColor: Colors.black,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
