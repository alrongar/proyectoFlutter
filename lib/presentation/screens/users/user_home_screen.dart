import 'package:eventify_flutter/config/rutes/app_routes.dart';
import 'package:eventify_flutter/models/event.dart';
import 'package:eventify_flutter/presentation/screens/events/info_event_screen.dart';
import 'package:eventify_flutter/presentation/widgets/cardevents/event_card.dart';
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

  static const Color backgroundColor = Color(0xFF1A1A2E);
  static const Color musicEventColor = Colors.yellow;
  static const Color sportEventColor = Colors.orange;
  static const Color technologyEventColor = Colors.green;
  static const Color defaultEventColor = Colors.black;

  static const String categoryAll = 'All';
  static const int categoryMusic = 1;
  static const int categorySport = 2;
  static const int categoryTechnology = 3;

  @override
  void initState() {
    super.initState();

    registeredEvents = eventServices.fetchRegisteredEvents();
  }

  bool _reloadEvents() {
    bool canReload = false;
    try {
      setState(() {
        registeredEvents = eventServices.fetchRegisteredEvents();
        canReload = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al recargar la pantalla')),
      );
    }
    return canReload;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder<List<Evento>>(
        future: registeredEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar eventos registrados'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final evento = snapshot.data![index];
                Color borderColor = getBorderColor(evento);
                return GestureDetector(
                  onTap: () => _showEventDetails(context, evento),
                  child: EventCard(evento: evento, borderColor: borderColor),
                );
              },
            );
          } else {
            return const Center(
                child: Text('No estás registrado en ningún evento.'));
          }
        },
      ),
    ]);
  }

  Color getBorderColor(Evento evento) {
    switch (evento.categoryid) {
      case categoryMusic:
        return musicEventColor;
      case categorySport:
        return sportEventColor;
      case categoryTechnology:
        return technologyEventColor;
      default:
        return defaultEventColor;
    }
  }

  Future<void> _showEventDetails(BuildContext context, Evento evento) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: 350,
                height: 550,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: Stack(
                  children: [
                    EventDetails(
                      evento: evento,
                      context,
                      onActionCompleted: () async {

                        final prefs = await SharedPreferences.getInstance();
                        final email = prefs.getString('email');
                        await _reloadEvents();
                        Navigator.pushNamed(context, AppRoutes.home,
                            arguments: email);

                         
                      },
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
