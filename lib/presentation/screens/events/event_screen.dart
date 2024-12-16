import 'package:eventify_flutter/presentation/screens/events/info_event_screen.dart';
import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../../../models/category.dart';
import '../../../providers/event_service.dart';
import 'package:eventify_flutter/presentation/widgets/cardevents/event_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isOrganizer = false;
  bool isUser = false;

  static const Color backgroundColor = Color(0xFF1A1A2E);
  static const Color musicEventColor = Colors.yellow;
  static const Color sportEventColor = Colors.orange;
  static const Color technologyEventColor = Colors.green;
  static const Color defaultEventColor = Colors.black;

  @override
  void initState() {
    super.initState();
    eventos = Future.value([]); // Inicializar eventos con una lista vacía
    _loadUserRole();
    categories = EventServices().fetchCategories();
  }

  Future<void> _loadUserRole() async {
    
    final prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    String? userId = prefs.getString('user_id'); // Recuperar user_id como String
    
    if (role == 'o') {
      setState(() {
        isOrganizer = true;
        eventos = EventServices().fetchEventosByOrganizer(userId!);
      print(eventos.toString());
      });
    } else if (role == 'u') {
      setState(() {
        isUser = true;
        eventos = EventServices().fetchEventos();
      });
    }
  }

  bool _reloadEvents() {
    bool canReload = false;
    try {
      setState(() {
        if (isOrganizer) {
          SharedPreferences.getInstance().then((prefs) {
            String? userId = prefs.getString('user_id'); // Recuperar user_id como String
            eventos = EventServices().fetchEventosByOrganizer(userId!);
          });
        } else {
          eventos = EventServices().fetchEventos();
        }
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
              if (selectedCategory != 'All') {
                eventos = eventos
                    .where((evento) => evento.category == selectedCategory)
                    .toList();
              }
              return ListView.builder(
                itemCount: eventos.length,
                itemBuilder: (context, index) {
                  Evento evento = eventos[index];
                  Color borderColor = getBorderColor(evento);
                  return GestureDetector(
                    onTap: () => _showEventDetails(context, evento, isOrganizer),
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
            child: FutureBuilder<List<Category>>(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error al cargar categorías');
                } else if (snapshot.hasData) {
                  List<Category> categories = snapshot.data!;
                  return Column(
                    children: categories.map((Category category) {
                      return Column(
                        children: [
                          CircleButton(
                            icon: Icons.category,
                            onPressed: () {
                              setState(() {
                                selectedCategory = category.name;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return Text('No hay categorías disponibles');
                }
              },
            ),
          ),
        if (isOrganizer)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createEvent').then((_) {
                  _reloadEvents();
                });
              },
              backgroundColor: backgroundColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Color getBorderColor(Evento evento) {
    switch (evento.category) {
      case 'Music':
        return musicEventColor;
      case 'Sport':
        return sportEventColor;
      case 'Technology':
        return technologyEventColor;
      default:
        return defaultEventColor;
    }
  }

  Future<void> _showEventDetails(BuildContext context, Evento evento, bool isOrganizer) async {
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
                      isOrganizer: isOrganizer,
                      onActionCompleted: () async {
                        bool canReload = await _reloadEvents();
                        Navigator.pop(context, canReload);
                      },
                    ),
                    Positioned(
                      top: 10,
                      right: 5,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    if (isOrganizer)
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/editEvent',
                                  arguments: evento,
                                ).then((_) {
                                  _reloadEvents();
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool confirmed = await _showDeleteConfirmationDialog(context);
                                if (confirmed) {
                                  try {
                                    await EventServices().deleteEvent(evento.id.toString());
                                    _reloadEvents();
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al eliminar el evento: $e')),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
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

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este evento?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    ) ?? false;
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
