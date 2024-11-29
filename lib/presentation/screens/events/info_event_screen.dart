import 'package:eventify_flutter/providers/event_service.dart';
import 'package:flutter/material.dart';
import '../../../models/event.dart';

class EventDetails extends StatefulWidget {
  final Evento evento;
  final VoidCallback onActionCompleted;

  EventDetails(BuildContext context, {super.key, required this.evento, required this.onActionCompleted});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  var btnText = '';

@override
  void initState() {
    super.initState();

    btnText = widget.evento.category == '' ? "Borrarse" : "Apuntarse";
  }

  @override
  Widget build(BuildContext context) {
    EventServices eventServices = new EventServices();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(1.0),
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.evento.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                '${widget.evento.imageUrl}',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            // Descripción del evento
            Text(
              widget.evento.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Fecha del evento
            Text(
              'Fecha: ${widget.evento.startTime}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.evento.category == '') {
                  try {
                    eventServices.unregisterEvent(widget.evento);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('¡Te has borrado del evento!')),
                    );
                    widget.onActionCompleted();
                  } catch (error) {
                    Navigator.pop(context, false);
                    print('Error al borrar del evento: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Hubo un problema al borrarse del evento.')
                      ),
                    );
                  }
                } else {

                  try {
                    eventServices.registerEvent(widget.evento);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('¡Te has apuntado al evento!')),
                    );
                    widget.onActionCompleted();
                  } catch (error) {
                    Navigator.pop(context, false);
                    print('Error al registrar el evento: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Hubo un problema al registrarte al evento.')),
                    );
                  }
                }

              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor:Color(0xFF001D3D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                btnText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
