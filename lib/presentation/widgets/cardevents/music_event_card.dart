import 'package:flutter/material.dart';
import '../../../models/event.dart';
import 'event_card.dart';

// Widget personalizado para eventos de Música
class MusicEventCard extends StatelessWidget {
  final Evento evento;

  MusicEventCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    return EventCard(
      evento: evento,
      borderColor: Color(0xFFFFD700), // Amarillo
    );
  }
}