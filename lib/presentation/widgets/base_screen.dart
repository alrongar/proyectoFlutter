import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/events/event_screen.dart';
import '../screens/users/admin_user_screen.dart';
import '../screens/report/report_screen.dart';
import '../screens/users/organaizer_screen.dart';
import '../screens/users/user_home_screen.dart';

class BaseScreen extends StatefulWidget {
  final String email;
  const BaseScreen({super.key, required this.email});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;
  bool _isAdmin = false;
  bool _isUser = false;
  bool _isOrganizer = false;
  bool _isAuthenticated = false;

  Future<void> _loadUserRoles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    if (authToken != null) {
      setState(() {
        _isAuthenticated = true;
        _isAdmin = prefs.getString('role') == 'a';
        _isUser = prefs.getString('role') == 'u';
        _isOrganizer = prefs.getString('role') == 'o';
      });
    } else {
      setState(() {
        _isAuthenticated = false;
      });
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserRoles();
  }

  List<Widget> get _pages {
    final List<Widget> pages = [];

    if (_isUser) {
      pages.addAll([
        const UserHomeScreen(),
        const EventosScreen(),
      ]);
      final email = ModalRoute.of(context)?.settings.arguments as String?;
      if (email?.isNotEmpty == true) {
        pages.add(ReportScreen(email: email!));
      }
    }

    

    if (_isAdmin) {
      pages.add(const UserListScreen());
    }

    

    if (_isOrganizer) {
    pages.addAll([
      const EventosScreen(),
      const OrganizerScreen(data: {}),
    ]);
  }

    return pages;
  }

  List<String> get _titles {
    final titles = [
      'Inicio',
      'Eventos',
    ];

    if (_isAdmin) {
      titles.add('Administración');
    }

    if (_isUser) {
      titles.add('Informe');
    }

    if (_isOrganizer) {
      titles.add('Organizador');
    }

    return titles;
  }

  List<BottomNavigationBarItem> get _menuItems {
    final items = <BottomNavigationBarItem>[];

  if (_isUser) {
    items.addAll([
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.event),
        label: 'Eventos',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.report),
        label: 'Informe',
      ),
    ]);
  }

  if (_isAdmin) {
    items.add(const BottomNavigationBarItem(
      icon: Icon(Icons.admin_panel_settings),
      label: 'Admin',
    ));
  }

  if (_isOrganizer) {
    items.addAll([
      const BottomNavigationBarItem(
        icon: Icon(Icons.event),
        label: 'Eventos',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Organizador',
      ),
    ]);
  }

  // Botón Logout para todos
  items.add(const BottomNavigationBarItem(
    icon: Icon(Icons.logout),
    label: 'Logout',
  ));

  return items;
  }

  void _onItemTapped(int index) {
    if (index == _menuItems.length - 1) {
      _logout();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF001D3D),
        title: Center(
          child: Text(
            _titles[_currentIndex],
            style: const TextStyle(
              color: Color(0xFFFFC300),
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        toolbarHeight: 70.0,
      ),
      body: _isAuthenticated
          ? _pages[_currentIndex]
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _isAuthenticated
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
              items: _menuItems,
              selectedItemColor: const Color(0xFFFFC300),
              unselectedItemColor: Colors.grey,
              backgroundColor: const Color(0xFF001D3D),
            )
          : null,
    );
  }

  Future<void> reLoadEvents({required int currentTabIndex}) async {
    try {
      setState(() {
        _currentIndex = currentTabIndex;
      });
    } catch (e) {
      print('Error al recargar eventos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Hubo un problema al recargar los eventos.')),
      );
    }
  }
}
