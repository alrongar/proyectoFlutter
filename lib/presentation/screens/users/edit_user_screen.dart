import 'package:eventify_flutter/presentation/widgets/shared/custom_button.dart';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:eventify_flutter/providers/user_service.dart';
import 'package:flutter/material.dart';
import '../../widgets/shared/custom_text_field.dart';

class UserEditScreen extends StatefulWidget {
  final String id;

  const UserEditScreen({super.key, required this.id});

  @override
  UserEditScreenState createState() => UserEditScreenState();
}

class UserEditScreenState extends State<UserEditScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<CustomTextFieldState> newNameKey = GlobalKey<CustomTextFieldState>();

  Future<void> editUser() async {
    var name = '';
    if (formKey.currentState?.validate() ?? false) {
      name = newNameKey.currentState!.textValue;
      await UserService.updateUser(widget.id, name); // Asegúrate de que la función sea asíncrona
      Navigator.pop(context); // Vuelve a la pantalla anterior después de actualizar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edición de Usuarios'),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 44, 60, 75),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GradientBackground(
        title: '',
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                  children: [
                    CustomTextField(
                      key: newNameKey,
                      hintTextContent: 'Nuevo nombre',
                      isRequired: true,
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      buttonText: 'Actualizar',
                      onPressed: () async {
                        await editUser(); // Espera la actualización
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
