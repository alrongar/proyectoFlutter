import 'package:flutter/material.dart';
import '../../../providers/event_service.dart';
import '../../../models/event.dart';
import '../../../models/category.dart';
import '../../widgets/cardevents/event_card.dart';

class EventosScreen extends StatefulWidget {
  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  final EventServices eventServices = EventServices();
  late Future<List<Evento>> eventos;
  late Future<List<Category>> categories;
  String selectedCategory = 'All';
  bool isFilterVisible = false;

  // colores
  static const Color backgroundColor = Color(0xFF1A1A2E);
  static const Color musicEventColor = Colors.yellow;
  static const Color sportEventColor = Colors.orange;
  static const Color technologyEventColor = Colors.green;
  static const Color defaultEventColor = Colors.black;

  //  tipos de eventos
  static const String categoryAll = 'All';
  static const String categoryMusic = 'Music';
  static const String categorySport = 'Sport';
  static const String categoryTechnology = 'Technology';

  @override
  void initState() {
    super.initState();
    eventos = eventServices.fetchEventos();
    categories = eventServices.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos", style: TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Evento>>(
        future: eventos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar eventos"));
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
                return EventCard(evento: evento, borderColor: borderColor);
              },
            );
          } else {
            return Center(child: Text("No se encontraron eventos"));
          }
        },
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 8,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isFilterVisible = !isFilterVisible;
                });
              },
              child: Icon(Icons.filter_list, color: Colors.white),
              backgroundColor: backgroundColor,
            ),
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
                  SizedBox(height: 16),
                  CircleButton(
                    icon: Icons.sports,
                    onPressed: () {
                      setState(() {
                        selectedCategory = categorySport;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  CircleButton(
                    icon: Icons.computer,
                    onPressed: () {
                      setState(() {
                        selectedCategory = categoryTechnology;
                      });
                    },
                  ),
                  SizedBox(height: 16),
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
        ],
      ),
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
