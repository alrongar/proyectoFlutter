import 'dart:convert';
import 'package:eventify_flutter/presentation/screens/users/edit_user_screen.dart';
import 'package:eventify_flutter/presentation/widgets/shared/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  Future<void> fetchUsers() async {
    var response = await UserService.getUsers();
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        users = jsonResponse['data'];
      });
    } else {
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
            var role = user['role'];
            var isActive = user['active'] == 1; // Comprueba si active es 1 para marcar como activo

            if (role == 'u') role = 'Usuario';
            else if (role == 'o') role = 'Organizador';

            double offsetX = 0.0; // Desplazamiento horizontal inicial
            bool isSwiped = false; // Indica si la tarjeta está deslizada

            return StatefulBuilder(
              builder: (context, setState) => GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    offsetX += details.primaryDelta!; // Actualiza el desplazamiento
                    if (offsetX > 200) {
                      offsetX = 200; // Limita el desplazamiento a 200 píxeles
                    }
                  });
                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    // Mantiene la posición si se alcanzó el límite
                    if (offsetX >= 200) {
                      isSwiped = true; // Marca la tarjeta como deslizada
                    } else {
                      offsetX = 0; // Restaura la posición si no se alcanza el límite
                    }
                  });
                },
                onTap: () {
                  // Vuelve a la posición inicial si se ha deslizado
                  if (isSwiped) {
                    setState(() {
                      offsetX = 0; // Restaura la posición
                      isSwiped = false; // Resetea el estado de deslizar
                    });
                  }
                },
                child: Stack(
                  children: [
                    // Fondo con botones que se muestran al deslizar
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10), // Espacio para que los botones no se superpongan con la tarjeta
                          // Botón para activar/desactivar el usuario
                          if (!isActive) // Si el usuario está inactivo
                            _buildIconButton(
                              icon: Icons.check,
                              color: Colors.green,
                              onPressed: () async {
                                await UserService.activateUser(id);
                                fetchUsers(); // Actualiza la lista de usuarios
                              },
                            )
                          else // Si el usuario está activo
                            _buildIconButton(
                              icon: Icons.block,
                              color: Colors.orange,
                              onPressed: () async {
                                await UserService.deactivateUser(id);
                                fetchUsers(); // Actualiza la lista de usuarios
                              },
                            ),
                          // Botón para editar el usuario
                          _buildIconButton(
                            icon: Icons.edit,
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserEditScreen(id: id.toString()),
                                ),
                              ).then((_) {
                                fetchUsers(); // Actualiza la lista después de volver
                              });
                            },
                          ),
                          // Botón para eliminar el usuario
                          _buildIconButton(
                            icon: Icons.delete,
                            color: Colors.red,
                            onPressed: () async {
                              bool confirmed = await _showDeleteConfirmationDialog();
                              if (confirmed) {
                                var response = await UserService.deleteUser(id);
                                if (response.statusCode == 200) { // Verificamos que la respuesta sea correcta
                                  fetchUsers(); // Actualiza la lista de usuarios
                                } else {
                                  // Manejo de error si la eliminación falla
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al eliminar el usuario: ${response.body}')),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // Tarjeta de usuario que se desliza
                    Transform.translate(
                      offset: Offset(offsetX, 0),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: const Color(0xFFBBDEFB),
                        child: ListTile(
                          leading: const Icon(Icons.person, size: 40),
                          title: Text(
                            '$name ($role)',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Método para mostrar el diálogo de confirmación de eliminación
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  // Widget para construir los botones de ícono
  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
