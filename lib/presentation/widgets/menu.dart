import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/rutes/app_routes.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  Future<bool> _isAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    return role == 'a';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<bool>(
        future: _isAdmin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                color: const Color(0xFF1A1A2E),
                child: const Center(
                  child: Text(
                    'MENÚ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _buildMenuItem(context, Icons.home, 'Home', AppRoutes.home),
              _buildMenuItem(context, Icons.event, 'Eventos', AppRoutes.eventos), // Nueva opción para Eventos
              if (snapshot.data == true)
                _buildMenuItem(context, Icons.admin_panel_settings, 'Panel de Administrador', AppRoutes.adminPanel),
              _buildMenuItem(context, Icons.logout, 'Logout', AppRoutes.login),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
