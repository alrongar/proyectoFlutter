
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final String title;

  const GradientBackground({
    required this.child,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Fondo transparente
      body: Stack(
        children: [
          // Fondo de gradiente en orientación vertical con tonos azul y blanco
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE3F2FD), // Azul muy claro (casi blanco)
                  Color(0xFF90CAF9), // Azul claro
                  Color(0xFF42A5F5), // Azul intermedio
                  Color(0xFF1E88E5), // Azul intenso
                ],
                stops: [0.1, 0.3, 0.6, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenido principal con el título centrado
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Color blanco para el título
                  fontFamily: 'Lobster',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: child), // Contenedor para el resto de los widgets
            ],
          ),
        ],
      ),
    );
  }
}
