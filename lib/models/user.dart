import 'dart:ffi';

class Usuario {
  final String id;
  final String nombre;
  final String email;
  final Char tipo;

  Usuario(this.tipo, {required this.id, required this.nombre, required this.email});
}
