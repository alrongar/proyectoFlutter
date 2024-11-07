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

  @override
  void initState() {
    super.initState();
    eventos = eventServices.fetchEventos(); // Obtener los eventos
    categories = eventServices.fetchCategories(); // Obtener las categorías
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
        backgroundColor: Color(0xFF1096FB), // Color azul similar al de Ticketmaster
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
            if (selectedCategory != 'All') {
              eventos = eventos.where((evento) => evento.category == selectedCategory).toList();
            }
            return ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                Evento evento = eventos[index];
                return EventCard(evento: evento, borderColor: Colors.blue); // Pasamos el color dinámico
              },
            );
          } else {
            return Center(child: Text("No se encontraron eventos"));
          }
        },
      ),
      floatingActionButton: buildFilterButton(),
    );
  }

  Widget buildFilterButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return FutureBuilder<List<Category>>(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error al cargar categorías"));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.event),
                        title: Text('Todos los eventos'),
                        onTap: () {
                          setState(() {
                            selectedCategory = 'All';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ...snapshot.data!.map((category) {
                        return ListTile(
                          leading: Icon(Icons.category),
                          title: Text(category.name),
                          onTap: () {
                            setState(() {
                              selectedCategory = category.name;
                            });
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ],
                  );
                } else {
                  return Center(child: Text("No se encontraron categorías"));
                }
              },
            );
          },
        );
      },
      child: Icon(Icons.filter_list),
    );
  }
}
