// lib/providers/usuario_provider.dart

import 'package:flutter/material.dart';
import '../models/user.dart';

class UsuarioProvider with ChangeNotifier {
  List<Usuario> _usuarios = [];

  List<Usuario> get usuarios => _usuarios;

  void obtenerUsuarios() {
    // Simulación de una llamada a una API o base de datos
    _usuarios = [
      Usuario(id: '1', nombre: 'Juan', email: 'juan@example.com', role: 'u'),
      Usuario(id: '2', nombre: 'María', email: 'maria@example.com', role: 'o'),
    ];
    notifyListeners(); // Notifica a los oyentes que los datos han cambiado
  }
}
