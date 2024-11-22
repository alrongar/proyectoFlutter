import 'package:eventify_flutter/models/event.dart';
import 'package:eventify_flutter/presentation/screens/events/event_screen.dart';
import 'package:eventify_flutter/providers/event_service.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  
  const UserHomeScreen({super.key});
  
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final EventServices eventServices = EventServices();
  late Future<List<Evento>> registeredEvents;

  @override
  void initState() {
    super.initState();
    registeredEvents = _fetchRegisteredEvents();
  }

  Future<List<Evento>> _fetchRegisteredEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final token = prefs.getString('token');

    if (userId == null || token == null) {
      return [];
    }


    return eventServices.fetchRegisteredEvents(userId, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Evento>>(
        future: registeredEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar eventos registrados'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final evento = snapshot.data![index];
                return ListTile(
                  title: Text(evento.title),
                  subtitle: Text('Fecha: ${evento.startTime}'),
                );
              },
            );
          } else {
            return const Center(child: Text('No estás registrado en ningún evento.'));
          }
        },
      ),
    );
  }
}
