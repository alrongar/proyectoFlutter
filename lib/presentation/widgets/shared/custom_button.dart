import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText; // Texto que mostrará el botón
  final VoidCallback? onPressed;

  const CustomButton({
    required this.buttonText,
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E88E5), // Color de fondo del botón (azul intermedio)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Bordes más redondeados
        ),
        padding: const EdgeInsets.symmetric(vertical: 18), // Espaciado interno
        elevation: 8, // Sombra para dar profundidad
        shadowColor: Colors.black.withOpacity(0.5), // Color de sombra
        minimumSize: const Size(200, 60), // Tamaño mínimo del botón (ancho, alto)
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white, // Color del texto
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

