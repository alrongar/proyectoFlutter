import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field.dart';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              const CustomButton(
                routeName: '/login',
                buttonText: 'Iniciar Sesión',
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
