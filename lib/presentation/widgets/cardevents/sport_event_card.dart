import 'package:flutter/material.dart';
import '../../../models/event.dart';
import 'event_card.dart';

class SportEventCard extends StatelessWidget {
  final Evento evento;

  SportEventCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    return EventCard(
      evento: evento,
      borderColor: Color(0xFFFF4500), // Naranja
    );
  }
}