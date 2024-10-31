// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class UsuarioProvider extends ChangeNotifier {
  bool _loading = false;
  List<Usuario> _usuarios = [];

  bool get loading => _loading;
  List<Usuario> get usuarios => _usuarios;

  Future<void> obtenerUsuarios() async {
    _loading = true;
    notifyListeners();

    const String url = 'https://eventify.allsites.es/public/api/users';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _usuarios = data.map((json) => Usuario(
          id: json['id'],
          nombre: json['name'],
          email: json['email'],
          role: json['role'],
        )).toList();
      } else {
        print("Error al obtener los usuarios: ${response.body}");
      }
    } catch (e) {
      print("Error de conexión: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
