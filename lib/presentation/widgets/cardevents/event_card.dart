import 'package:flutter/material.dart';
import '../../../models/event.dart';

class EventCard extends StatelessWidget {
  final Evento evento;
  final Color borderColor;

  EventCard({required this.evento, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned.fill(
              child: Image.network(
                evento.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Fondo oscuro semitransparente para la información
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            // Contenido encima de la imagen
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del evento
                  Text(
                    evento.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Fecha del evento
                  Text(
                    'Fecha: ${evento.startTime.day}/${evento.startTime.month}/${evento.startTime.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 15),
                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
