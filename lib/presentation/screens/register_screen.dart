import 'package:eventify_flutter/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';
import 'package:eventify_flutter/presentation/widgets/shared/custom_text_field_stful.dart';

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
  final GlobalKey<CustomTextFieldStfulState> emailKey =
      GlobalKey<CustomTextFieldStfulState>();
  final GlobalKey<CustomTextFieldStfulState> passwordKey =
      GlobalKey<CustomTextFieldStfulState>();
  final GlobalKey<CustomTextFieldStfulState> nameKey =
      GlobalKey<CustomTextFieldStfulState>();
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
              CustomTextFieldStful(
                key: nameKey,
                hintTextContent: 'Nombre',
                isRequired: true,
              ),
              const SizedBox(height: 30),
              CustomTextFieldStful(
                key: emailKey,
                hintTextContent: 'Email',
                regularExpression:
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              ),
              const SizedBox(height: 30),
              CustomTextFieldStful(
                key: passwordKey,
                hintTextContent: 'Contraseña',
                isPassword: true,
                isRequired: true,
              ),
              const SizedBox(height: 30),
              if (errorMessage != null) ErrorBullet(message: errorMessage!),
              CustomButton(
                routeName:
                    '', // Aquí puedes definir la ruta a la que redirigir después del registro
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
                  Navigator.pushNamed(
                      context, '/login'); // Navegar a la pantalla de login
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
