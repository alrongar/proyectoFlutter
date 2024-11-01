import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  static const String baseUrl = 'https://eventify.allsites.es/public/api';

  // Método privado para obtener los encabezados
  static Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<http.Response> activateUser(String id) async {
    return await _postUserAction('$baseUrl/activate', id);
  }

  static Future<http.Response> deactivateUser(String id) async {
    return await _postUserAction('$baseUrl/deactivate', id);
  }

  static Future<http.Response> _postUserAction(String url, String id) async {
    Map<String, String> headers = await _getHeaders();
    var body = json.encode({"id": id});

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.body}');
    }

    return response;
  }

  static Future<http.Response> getUsers() async {
    var url = Uri.parse('$baseUrl/users');
    var headers = await _getHeaders();

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.body}');
    }

    return response;
  }

  static Future<http.Response> deleteUser(String userId) async {
    var url = Uri.parse('$baseUrl/deleteUser');
    Map<String, String> headers = await _getHeaders();
    var body = json.encode({"id": userId});

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.body}');
    }

    return response;
  }

  static Future<http.Response> updateUser(String userId, String newName) async {
    var url = Uri.parse('$baseUrl/updateUser');
    Map<String, String> headers = await _getHeaders();
    var body = jsonEncode({
      "id": userId,
      "name": newName,
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.body}');
    }

    return response;
  }

  static String getTranslatedMessage(Map<String, dynamic> data) {
    final error = data['data']?['error'] ?? 'Error desconocido';

    final translatedMessages = {
      'User or password incorrect': 'Datos incorrectos',
      'Email don\'t confirmed': 'Email no confirmado',
      'User don\'t activated': 'Email no activado',
      'User deleted': 'Usuario eliminado',
    };

    return translatedMessages[error] ?? 'Error desconocido';
  }
}
