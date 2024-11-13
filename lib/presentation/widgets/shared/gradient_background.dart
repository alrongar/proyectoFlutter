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
      backgroundColor: const Color(0xFF001D3D), // Fondo azul oscuro
      body: Stack(
        children: [
          // Fondo de color sólido
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF001D3D), // Azul oscuro
          ),
          // Superposición negra transparente para mejorar el contraste
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenido principal
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A), // Usando el color $color_2
                  fontFamily: 'Lobster',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: child),
            ],
          ),
        ],
      ),
    );
  }
}
