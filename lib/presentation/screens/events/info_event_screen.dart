import 'package:eventify_flutter/providers/event_service.dart';
import 'package:flutter/material.dart';
import '../../../models/event.dart';

class EventDetails extends StatelessWidget {
  final Evento evento;

  EventDetails({required this.evento});

  @override
  Widget build(BuildContext context) {
    EventServices eventServices = new EventServices();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4), // Cambiar la posición de la sombra
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título del evento
            Text(
              evento.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Imagen del evento (con un tamaño fijo para mantener el diseño limpio)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                evento.imageUrl,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            // Descripción del evento
            Text(
              'Descripción: Aquí iría la descripción completa del evento.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Fecha del evento
            Text(
              'Fecha: ${evento.startTime}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Botón para apuntarse al evento
            ElevatedButton(
              onPressed: () {
                try {
                  eventServices.registerEvent(evento);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡Te has apuntado al evento!')),
                  );
                } catch (error) {
                  print('Error al registrar el evento: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Hubo un problema al registrarte al evento.')),
                  );
                }
              },
              child: Text(
                'Apuntarse',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
