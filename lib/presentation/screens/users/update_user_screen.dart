import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../providers/UserService.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const UpdateUserScreen({super.key, required this.userId, required this.userName});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName; // Inicializar el campo con el nombre actual
  }

  @override
  void dispose() {
    _nameController.dispose(); // Limpiar el controlador al destruir el widget
    super.dispose();
  }

  Future<void> _updateUser() async {
    var response = await UserService.updateUser(widget.userId, _nameController.text);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre actualizado correctamente')),
      );
      Navigator.of(context).pop(); // Cerrar la pantalla después de la actualización
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Usuario'),
        backgroundColor: const Color(0xff620091),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff620091),
              ),
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
