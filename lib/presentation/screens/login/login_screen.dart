import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';
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
  final GlobalKey<CustomTextFieldState> emailKey =
      GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> passwordKey =
      GlobalKey<CustomTextFieldState>();
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
                child: Icon(Icons.person),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                key: emailKey,
                hintTextContent: 'Email',
                regularExpression:
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
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
              const SizedBox(height: 20),
              const CustomButton(
                buttonText: 'Registrarse',
                routeName: '/register',
              )
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
            final isValidPassword = passwordKey.currentState?.isValid ?? false;

            if (isValidEmail && isValidPassword) {
              print('Email: $email');
              print('Contraseña: $password');
            } else {
              if (!isValidEmail) {
                onError('Email no válido');
              }
              if (!isValidPassword) {
                onError('Contraseña no válida');
              }
            }
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
          Expanded(
              child: Text(message, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String hintTextContent;
  final bool isPassword;
  final String? regularExpression;
  final bool isRequired;

  const CustomTextField({
    super.key,
    this.hintTextContent = '',
    this.isPassword = false,
    this.regularExpression,
    this.isRequired = false,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool _isValid = false;

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UnderlineInputBorder outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    final inputDecoration = InputDecoration(
      hintText: widget.hintTextContent,
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      errorBorder: outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.red),
      ),
      filled: true,
    );

    return TextFormField(
      focusNode: focusNode,
      controller: textController,
      decoration: inputDecoration,
      obscureText: widget.isPassword,
      validator: (value) {
        final validationResult =
            validateExpression(textFieldValue: value ?? '');
        setState(() {
          _isValid = validationResult == null;
        });
        return validationResult;
      },
    );
  }

  String? validateExpression({required String textFieldValue}) {
    if (widget.isRequired && textFieldValue.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    if (widget.regularExpression != null &&
        widget.regularExpression!.isNotEmpty) {
      final regex = RegExp(widget.regularExpression!);
      if (!regex.hasMatch(textFieldValue)) {
        return 'Entrada inválida';
      }
    }
    return null;
  }

  String get textValue => textController.value.text;

  bool get isValid => _isValid;
}
