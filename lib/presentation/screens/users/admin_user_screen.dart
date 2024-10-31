import 'dart:convert';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:flutter/material.dart';
import '../../../providers/UserService.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = []; // Lista para almacenar los usuarios

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Llamada inicial para obtener los usuarios
  }

  // Método para obtener la lista de usuarios desde el servicio
  Future<void> fetchUsers() async {
    var response = await UserService.getUsers();
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        users = jsonResponse['data']; // Almacenamos los usuarios en la lista
      });
    } else {
      // Manejo de errores
      print('Error: ${response.statusCode}');
      print('Mensaje: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Administración de Usuarios'),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color.fromARGB(255, 44, 60, 75),
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        body: users.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GradientBackground(
                title: '',
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    var name = user['name'];
                    var email = user['email'];
                    var role = user['role'];
                    if (role == 'u') {
                      role = 'Usuario';
                    } else if (role == 'o') {
                      role = 'Organizador';
                    }
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: const Color.fromARGB(255, 82, 112, 138),
                      
                      child: ListTile(
                        title: Text('$name || Email: $email || Rol: $role' ??
                            'Nombre no disponible'),
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    );
                  },
                ),
              ));
  }
}
