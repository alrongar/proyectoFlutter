import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/category.dart';
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

  Future<List<Category>> fetchCategories() async {
    try {
      final token = await _getToken(); // Obtener el token
      final response = await http.get(
        Uri.parse('https://eventify.allsites.es/public/api/categories'),
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

          List<Category> categories = jsonList.map((json) {
            return Category.fromJson(json);
          }).toList();

          return categories;
        } else {
          throw Exception('No se pudo obtener categorías: ${jsonResponse['message']}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Error de autenticación. Token inválido o expirado.');
      } else {
        throw Exception('Error al cargar categorías. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en fetchCategories: $e'); // Para depuración
      throw Exception('Error: $e');
    }
  }
}
