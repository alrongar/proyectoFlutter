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
          // Fondo de gradiente en orientación vertical
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A1A2E), // Azul oscuro
                  Color(0xFF16213E), // Azul más oscuro
                  Color(0xFF0F3460), // Azul medianoche
                  Color(0xFF53354A), // Morado oscuro
                ],
                stops: [0.1, 0.3, 0.5, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenido principal con el título
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent.shade100,
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
