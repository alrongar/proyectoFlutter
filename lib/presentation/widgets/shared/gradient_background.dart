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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFA7DDFF),
                  Color(0xFF68B9FF),
                  Color(0xFF35A7FF),
                  Color(0xFF1096FB),
                ],
                stops: [0.1, 0.4, 0.7, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
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
