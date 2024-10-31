// lib/presentation/screens/admin_user_screen.dart
import 'package:eventify_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUserScreen extends StatelessWidget {
  const AdminUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);


    usuarioProvider.obtenerUsuarios();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios Registrados'),
      ),
      body: usuarioProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: usuarioProvider.usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarioProvider.usuarios[index];
          return ListTile(
            title: Text(usuario.nombre),
            subtitle: Text(usuario.email),
            trailing: Text(usuario.role),
          );
        },
      ),
    );
  }
}
