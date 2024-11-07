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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del evento con bordes redondeados
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              evento.imageUrl, // Asegúrate de que el campo sea imageUrl
              height: 500, // Tamaño de la imagen
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Detalles del evento
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del evento
                Text(
                  evento.title, // Asegúrate de que el campo sea title
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                // Fecha del evento
                Text(
                  'Fecha: ${evento.startTime.day}/${evento.startTime.month}/${evento.startTime.year}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 15),
                // Botón de acción (Ejemplo: Comprar entrada)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
