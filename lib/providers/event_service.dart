import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventServices {
  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  Future<List<Evento>> fetchEventos() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('https://eventify.allsites.es/public/api/events'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          List<dynamic> jsonList = jsonResponse['data'];
          return jsonList.map((json) => Evento.fromJson(json)).toList();
        } else {
          throw Exception('No se pudo obtener eventos: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Error al cargar eventos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en fetchEventos: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<Evento>> fetchEventosByOrganizer(String organizerId) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('https://eventify.allsites.es/public/api/events?organizer_id=$organizerId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          List<dynamic> jsonList = jsonResponse['data'];
          return jsonList.map((json) => Evento.fromJson(json)).toList();
        } else {
          throw Exception('No se pudo obtener eventos: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Error al cargar eventos. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en fetchEventosByOrganizer: $e');
      throw Exception('Error: $e');
    }
  }

  Future<int> createEvent(Evento evento) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('https://eventify.allsites.es/public/api/events'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'organizer_id': evento.organizerId,
          'title': evento.title,
          'description': evento.description,
          'category_id': evento.categoryid,
          'start_time': evento.startTime.toIso8601String(),
          'end_time': evento.endTime?.toIso8601String(),
          'location': evento.location,
          'price': evento.price,
          'image_url': evento.imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data']['id'];
      } else {
        print('Error al crear el evento. Código: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        throw Exception('Error al crear el evento. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en createEvent: $e');
      throw Exception('Error al crear el evento');
    }
  }

  Future<void> updateEvent(Evento evento) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('https://eventify.allsites.es/public/api/events/${evento.id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(evento.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar el evento. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en updateEvent: $e');
      throw Exception('Error al actualizar el evento');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('https://eventify.allsites.es/public/api/events/$eventId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el evento. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en deleteEvent: $e');
      throw Exception('Error al eliminar el evento');
    }
  }

  // Obtener categorías
  Future<List<Category>> fetchCategories() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('https://eventify.allsites.es/public/api/categories'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          List<dynamic> jsonList = jsonResponse['data'];
          return jsonList.map((json) => Category.fromJson(json)).toList();
        } else {
          throw Exception(
              'No se pudo obtener categorías: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Error al cargar categorías. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en fetchCategories: $e');
      throw Exception('Error: $e');
    }
  }

  // Registrar a un usuario en un evento
  Future<Map<String, dynamic>> registerEvent(Evento evento) async {
    try {
      final token = await _getToken();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      final response = await http.post(
        Uri.parse('https://eventify.allsites.es/public/api/registerEvent'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'event_id': evento.id,
          'registered_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Error al registrar evento. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en registerEvent: $e');
      throw Exception('Error: $e');
    }
  }

  //quitar a un usuario de un evento
  Future<Map<String, dynamic>> unregisterEvent(Evento evento) async {
    try {
      final token = await _getToken();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final response = await http.post(
        Uri.parse('https://eventify.allsites.es/public/api/unregisterEvent'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'event_id': evento.id,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Error al salir del evento. codigo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en unregisterEvent: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<Evento>> fetchRegisteredEvents() async {
    try {
      final token = await _getToken();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final response = await http.post(
        Uri.parse(
            'https://eventify.allsites.es/public/api/eventsByUser?id=$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        
      );

      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success']) {
          //print(jsonResponse);
          List<dynamic> data = jsonResponse['data'];
          
          return data.map((json) => Evento.fromJson(json)).toList();
        } else {
          
          throw Exception(
              'Error al obtener eventos registrados: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Error en la solicitud. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en fetchRegisteredEvents: $e');
      throw Exception('Error al obtener eventos registrados');
    }
  }
}
