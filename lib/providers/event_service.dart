import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventServices {

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Asegúrate de usar el nombre correcto
  }

  Future<List<Evento>> fetchEventos() async {
    try {
      final token = await _getToken(); // Obtener el token
      final response = await http.get(
        Uri.parse('https://eventify.allsites.es/public/api/events'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Analizar la respuesta JSON
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          List<dynamic> jsonList = jsonResponse['data'];

          List<Evento> eventos = jsonList.map((json) {
            return Evento.fromJson(json);
          }).toList();

          // Filtrar eventos que aún no han comenzado
          // DateTime now = DateTime.now();
          // eventos = eventos.where((evento) => evento.startTime.isAfter(now)).toList(); // Filtrando eventos que aún no han comenzado

          // Ordenar eventos de más nuevo a más antiguo
          // eventos.sort((a, b) => b.startTime.compareTo(a.startTime)); // Ordenando eventos de más nuevo a más antiguo

          return eventos;
        } else {
          throw Exception('No se pudo obtener eventos: ${jsonResponse['message']}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Error de autenticación. Token inválido o expirado.');
      } else {
        throw Exception('Error al cargar eventos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en fetchEventos: $e'); // Para depuración
      throw Exception('Error: $e');
    }
  }
}
