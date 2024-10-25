import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00FFAB), // Verde neón
            Color(0xFF00D1FF), // Azul neón
            Color(0xFF3E00FF), // Morado neón
            Color(0xFFFF007A), // Rosa neón
          ],
          stops: [0.1, 0.4, 0.7, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
