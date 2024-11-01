import 'dart:convert';
import 'package:eventify_flutter/presentation/screens/users/edit_user_screen.dart';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:flutter/material.dart';
import '../../../providers/user_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  UserListScreenState createState() => UserListScreenState();
}

class UserListScreenState extends State<UserListScreen> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    // Estilo uniforme para los botones con tamaño de fuente reducido
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      minimumSize: const Size.fromHeight(50), // Tamaño uniforme
    );

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
        ),
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GradientBackground(
        title: '',
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            var id = user['id'];
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
              color: const Color(0xFFBBDEFB), // Azul medio
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Espaciado interno
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, size: 40),
                      title: Text(
                        '$name ($role)',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('$email'),
                    ),
                    const SizedBox(height: 16), // Espacio entre ListTile y los botones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              UserService.activateUser(id);
                            },
                            style: buttonStyle.copyWith(
                              backgroundColor: const WidgetStatePropertyAll(Colors.green),
                            ),
                            child: const Text('Activar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              UserService.deactivateUser(id);
                            },
                            style: buttonStyle.copyWith(
                              backgroundColor: const WidgetStatePropertyAll(Colors.red),
                            ),
                            child: const Text('Desactivar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserEditScreen(id: id.toString()),
                                ),
                              );
                            },
                            style: buttonStyle.copyWith(
                              backgroundColor: const WidgetStatePropertyAll(Colors.blue),
                            ),
                            child: const Text('Editar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              UserService.deleteUser(id);
                            },
                            style: buttonStyle.copyWith(
                              backgroundColor: const WidgetStatePropertyAll(Colors.grey),
                            ),
                            child: const Text('Eliminar'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16), // Espacio adicional entre los botones y el fondo del Card
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
