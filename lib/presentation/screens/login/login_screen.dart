import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: const Text('Login', style: TextStyle(fontSize: 30)),
      ),
      body: const LoginElements(),
    );
  }
}

class LoginElements extends StatefulWidget {
  const LoginElements({
    super.key,
  });

  @override
  LoginElementsState createState() => LoginElementsState();
}

class LoginElementsState extends State<LoginElements> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<CustomTextFieldState> emailKey = GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> passwordKey = GlobalKey<CustomTextFieldState>();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              const CircleAvatar(
                radius: 120,
                child: Icon(Icons.person),
              ),
              const SizedBox(height: 50),
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
              ),
              const SizedBox(height: 50),
              if (errorMessage != null)
                ErrorBullet(message: errorMessage!),
              LoginButton(
                formKey: formKey,
                emailKey: emailKey,
                passwordKey: passwordKey,
                onError: (message) {
                  setState(() {
                    errorMessage = message;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final GlobalKey<CustomTextFieldState> emailKey;
  final GlobalKey<CustomTextFieldState> passwordKey;
  final Function(String) onError;

  const LoginButton({
    required this.formKey,
    required this.emailKey,
    required this.passwordKey,
    required this.onError,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            final email = emailKey.currentState?.textValue ?? '';
            final password = passwordKey.currentState?.textValue ?? '';
            final isValidEmail = emailKey.currentState?.isValid ?? false;

            if (isValidEmail) {
              print('Email: $email');
              print('Contraseña: $password');
            } else {
              onError('Email no válido');
            }
          } else {
            onError('Formulario no válido');
          }
        },
        child: const Text('Iniciar Sesión'),
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