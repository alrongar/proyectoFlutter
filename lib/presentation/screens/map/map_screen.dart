import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _currentLocation;
  final Location _locationService = Location();
  late final MapController _mapController;

  // Lista de eventos con latitud y longitud
  final List<Map<String, dynamic>> eventos = [
    {"nombre": "Evento 1", "latitud": 40.7128, "longitud": -74.0060},
    {"nombre": "Evento 2", "latitud": 34.0522, "longitud": -118.2437},
    {"nombre": "Evento 3", "latitud": 51.5074, "longitud": -0.1278},
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      PermissionStatus permissionGranted = await _locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      final location = await _locationService.getLocation();
      setState(() {
        _currentLocation = location;
      });

      _mapController.move(
        LatLng(location.latitude!, location.longitude!),
        13.0,
      );
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          zoom: 13.0,
          maxZoom: 18.0,
          minZoom: 5.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              // Marcador para la posición actual
              Marker(
                point: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                builder: (ctx) => Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                  size: 40.0,
                ),
              ),
              // Marcadores dinámicos para los eventos
              ...eventos.map((evento) {
                return Marker(
                  point: LatLng(evento['latitud'], evento['longitud']),
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      _showEventDetails(context, evento['nombre']);
                    },
                    child: Icon(
                      Icons.event,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, String nombre) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Detalles del evento'),
        content: Text('Nombre: $nombre'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
