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
  bool isFilterVisible = false; // Estado para mostrar u ocultar los botones de filtro

  @override
  void initState() {
    super.initState();
    eventos = eventServices.fetchEventos(); // Obtener los eventos
    categories = eventServices.fetchCategories(); // Obtener las categorías
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      title: Text("Eventos", style: TextStyle(color: Colors.white)), // Título blanco
      backgroundColor: Color(0xFF1A1A2E), // Color azul oscuro
      foregroundColor: Colors.white, // Asegura que los íconos del AppBar sean blancos
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

                // Aquí determinamos el color del borde basado en el tipo o categoría del evento
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
          // El botón flotante principal (ícono de filtro)
          Positioned(
            bottom: 20,
            right: 8,  // Ajuste al lado derecho
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isFilterVisible = !isFilterVisible; // Alternar la visibilidad de los botones
                });
              },
              child: Icon(Icons.filter_list, color: Colors.white), // Ícono blanco
              backgroundColor: Color(0xFF1A1A2E), // Color azul oscuro
            ),
          ),
          // Botones circulares flotantes (solo si están visibles)
          if (isFilterVisible)
            Positioned(
              bottom: 80, // Ajusta esta distancia para posicionar los botones sobre el FloatingActionButton
              right: 8,   // Mover más a la derecha
              child: Column(
                children: [
                  CircleButton(
                    icon: Icons.music_note,
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Music';
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  CircleButton(
                    icon: Icons.sports,
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Sport';
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  CircleButton(
                    icon: Icons.computer,
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Tech';
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

  // Función para obtener el color del borde dependiendo del evento
  Color getBorderColor(Evento evento) {
    switch (evento.category) {
      case 'Music':
        return Colors.yellow;
      case 'Sport':
        return Colors.orange;
      case 'Tech':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  // Widget para los botones circulares
  Widget CircleButton({required IconData icon, required VoidCallback onPressed}) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Color(0xFF1A1A2E), // Color azul oscuro
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
