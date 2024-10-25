import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String routeName;
  final String buttonText;

  const CustomButton({
    required this.routeName,
    super.key,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navegar directamente a la ruta
        Navigator.pushNamed(context, routeName);
      },
      child: Text(buttonText),
    );
  }
}
