// lib/presentation/screens/usuario_screen.dart
import 'package:eventify_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioScreen extends StatelessWidget {
  const UsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    // Cargar usuarios al construir la pantalla
    usuarioProvider.obtenerUsuarios();

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Usuarios')),
      body: ListView.builder(
        itemCount: usuarioProvider.usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarioProvider.usuarios[index];
          return ListTile(
            title: Text(usuario.nombre),
            subtitle: Text(usuario.email),
          );
        },
      ),
    );
  }
}
