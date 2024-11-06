import 'package:flutter/material.dart';
import '../../../providers/event_service.dart';
import '../../../models/event.dart';
import '../../widgets/cardevents/event_card.dart';


class EventosScreen extends StatefulWidget {
  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  final EventServices eventServices = EventServices();
  late Future<List<Evento>> eventos;

  @override
  void initState() {
    super.initState();
    eventos = eventServices.fetchEventos(); // Obtener los eventos
  }

  // Función para asignar el color del borde dependiendo del tipo de evento
  Color getBorderColor(String tipoEvento) {
    switch (tipoEvento) {
      case 'Music':
        return Color(0xFFFFD700); // Amarillo para música
      case 'Sport':
        return Color(0xFFFF4500); // Naranja para deporte
      case 'Tech':
        return Color(0xFF4CAF50); // Verde para tecnología
      default:
        return Color(0xFF1096FB); // Azul como color predeterminado
    }
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Evento evento = snapshot.data![index];
                Color borderColor = getBorderColor(evento.tipo);
                return EventCard(evento: evento, borderColor: borderColor); // Pasamos el color dinámico
              },
            );
          } else {
            return Center(child: Text("No se encontraron eventos"));
          }
        },
      ),
    );
  }
}
