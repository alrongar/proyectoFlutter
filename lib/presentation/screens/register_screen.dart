import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: const Text('Registro', style: TextStyle(fontSize: 30)),
      ),
      body: const RegisterElements(),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),
              const CircleAvatar(
                radius: 120,
                child: Icon(Icons.person_add),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                key: nameKey,
                hintTextContent: 'Nombre',
                isRequired: true,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                key: emailKey,
                hintTextContent: 'Email',
                regularExpression: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              ),
              const SizedBox(height: 30),
              CustomTextField(
                key: passwordKey,
                hintTextContent: 'Contraseña',
                isPassword: true,
                isRequired: true,
              ),
              const SizedBox(height: 30),
              if (errorMessage != null) ErrorBullet(message: errorMessage!),
              CustomButton(
                routeName: '', // Aquí puedes definir la ruta a la que redirigir después del registro
                buttonText: 'Registrarse',
                onPressed: () {
                  // Aquí puedes manejar la lógica de registro, como validar el formulario y enviar los datos.
                  if (formKey.currentState!.validate()) {
                    // Si la validación es exitosa, puedes continuar con el registro
                  }
                },
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login'); // Navegar a la pantalla de login
                },
                child: const Text('¿Ya tienes una cuenta? Inicia sesión aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorBullet extends StatelessWidget {
  final String message;

  const ErrorBullet({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
