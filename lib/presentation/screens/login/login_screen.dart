import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: const LoginElements(),
      );
  }
}

class LoginElements extends StatelessWidget {
  const LoginElements({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 120,
              child: Icon(Icons.person),
            ),
            const SizedBox(height: 20),
            CustomTextField(hintTextContent: 'Introduce tu email'),
            const SizedBox(height: 20),
            CustomTextField(hintTextContent: 'Introduce tu contraseña', isPassword: true,)
          ],
        ),
      ),
    );
  }
}