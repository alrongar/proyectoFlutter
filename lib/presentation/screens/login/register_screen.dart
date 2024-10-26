import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field.dart';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
        title: '',
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image(
                  image: AssetImage('assets/Eventify_logo.png'),
                  width:
                      230, // Ajuste de tamaño más pequeño para ocupar menos espacio
                  height: 230,
                  fit: BoxFit
                      .contain, // Ajusta el tamaño sin agregar espacio extra
                ),
              ),
              RegisterElements(), // Espacio flexible inferior
            ],
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
  final GlobalKey<CustomTextFieldState> nameKey =
      GlobalKey<CustomTextFieldState>();
  String? errorMessage;

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
          const SizedBox(height: 40),
          const CustomButton(
            routeName: '/login',
            buttonText: 'Registrarse',
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
          )
        ],
      ),
    );
  }
}
