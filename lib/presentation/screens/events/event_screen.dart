import 'package:eventify_flutter/presentation/screens/events/info_event_screen.dart';
import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../../../models/category.dart';
import '../../../providers/event_service.dart';
import 'package:eventify_flutter/presentation/widgets/cardevents/event_card.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  final EventServices eventServices = EventServices();
  late Future<List<Evento>> eventos;
  late Future<List<Category>> categories;
  String selectedCategory = 'All';
  bool isFilterVisible = false;

  static const Color backgroundColor = Color(0xFF1A1A2E);
  static const Color musicEventColor = Colors.yellow;
  static const Color sportEventColor = Colors.orange;
  static const Color technologyEventColor = Colors.green;
  static const Color defaultEventColor = Colors.black;

  static const String categoryAll = 'All';
  static const String categoryMusic = 'Music';
  static const String categorySport = 'Sport';
  static const String categoryTechnology = 'Technology';

  @override
  void initState() {
    super.initState();
    eventos = EventServices().loadEvents();
    
    categories = eventServices.fetchCategories();
  }

  void _reloadEvents() {
    setState(() {
      eventos = eventServices.loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<Evento>>(
          future: eventos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error al cargar eventos"));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<Evento> eventos = snapshot.data!;
              if (selectedCategory != categoryAll) {
                eventos = eventos.where((evento) => evento.category == selectedCategory).toList();
              }
              return ListView.builder(
                itemCount: eventos.length,
                itemBuilder: (context, index) {
                  Evento evento = eventos[index];
                  Color borderColor = getBorderColor(evento);
                  return GestureDetector(
                    onTap: () => _showEventDetails(context, evento),
                    child: EventCard(evento: evento, borderColor: borderColor),
                  );
                },
              );
            } else {
              return const Center(child: Text("No se encontraron eventos"));
            }
          },
        ),
        if (isFilterVisible)
          Positioned(
            bottom: 80,
            right: 8,
            child: Column(
              children: [
                CircleButton(
                  icon: Icons.music_note,
                  onPressed: () {
                    setState(() {
                      selectedCategory = categoryMusic;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CircleButton(
                  icon: Icons.sports,
                  onPressed: () {
                    setState(() {
                      selectedCategory = categorySport;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CircleButton(
                  icon: Icons.computer,
                  onPressed: () {
                    setState(() {
                      selectedCategory = categoryTechnology;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CircleButton(
                  icon: Icons.all_inclusive,
                  onPressed: () {
                    setState(() {
                      selectedCategory = categoryAll;
                    });
                  },
                ),
              ],
            ),
          ),
        Positioned(
          bottom: 20,
          right: 8,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                isFilterVisible = !isFilterVisible;
              });
            },
            child: const Icon(Icons.filter_list, color: Colors.white),
            backgroundColor: backgroundColor,
          ),
        ),
      ],
    );
  }

  Color getBorderColor(Evento evento) {
    switch (evento.category) {
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
    final shouldReload = await showModalBottomSheet(
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
                    EventDetails(evento: evento, context,
                     onActionCompleted: () {
                      Navigator.pop(context, true); // Indica que se debe recargar
                    },),
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

    if (shouldReload == true) {
    setState(() {
        _reloadEvents();
    });
  }
  }

  Widget CircleButton({required IconData icon, required VoidCallback onPressed}) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: backgroundColor,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
