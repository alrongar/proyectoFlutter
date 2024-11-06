import 'package:flutter/material.dart';
import '../../../models/event.dart';
import 'event_card.dart';

class TechEventCard extends StatelessWidget {
  final Evento evento;

  TechEventCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    return EventCard(
      evento: evento,
      borderColor: Color(0xFF4CAF50), // Verde
    );
  }
}