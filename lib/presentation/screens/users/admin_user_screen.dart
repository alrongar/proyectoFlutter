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

  Future<void> fetchUsers() async {
    var response = await UserService.getUsers();
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        users = jsonResponse['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administración de Usuarios'),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4CAF50), // Color claro
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
            return _buildUserCard(user);
          },
        ),
      ),
    );
  }

  Widget _buildUserCard(dynamic user) {
    var id = user['id'];
    var name = user['name'];
    var role = user['role'] == 'u' ? 'Usuario' : 'Organizador';
    var isActive = user['actived'] == 1;

    double offsetX = 0.0;
    bool isSwiped = false;

    return StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            offsetX += details.primaryDelta!;
            if (offsetX > 200) {
              offsetX = 200;
            }
          });
        },
        onHorizontalDragEnd: (details) {
          setState(() {
            if (offsetX >= 200) {
              isSwiped = true;
            } else {
              offsetX = 0;
            }
          });
        },
        onTap: () {
          if (isSwiped) {
            setState(() {
              offsetX = 0;
              isSwiped = false;
            });
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  _buildActionButton(
                    icon: isActive ? Icons.block : Icons.check,
                    color: isActive ? Colors.orange : Colors.green,
                    onPressed: () async {
                      if (isActive) {
                        await UserService.deactivateUser(id.toString());
                      } else {
                        await UserService.activateUser(id.toString());
                      }
                      fetchUsers();
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.edit,
                    color: Colors.amber, // Color del botón de editar cambiado
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserEditScreen(id: id.toString()),
                        ),
                      ).then((_) {
                        fetchUsers();
                      });
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: () async {
                      bool confirmed = await _showDeleteConfirmationDialog();
                      if (confirmed) {
                        var response = await UserService.deleteUser(id.toString());
                        if (response.statusCode == 200) {
                          fetchUsers();
                        } else {
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
            Transform.translate(
              offset: Offset(offsetX, 0),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                color: const Color(0xFFBBDEFB),
                child: ListTile(
                  leading: const Icon(Icons.person, size: 40),
                  title: Text(
                    '$name ($role)',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildActionButton({
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
