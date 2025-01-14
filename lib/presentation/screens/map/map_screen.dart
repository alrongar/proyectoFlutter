import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:convert';

import '../../../models/event.dart';
import '../../../providers/event_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _currentLocation;
  final Location _locationService = Location();
  late final MapController _mapController;
  late Future<List<Evento>> _eventosFuture;
  final EventServices _eventServices = EventServices();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
    _eventosFuture = _eventServices.fetchEventos();
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

      if (_currentLocation != null) {
        _mapController.move(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          13.0,
        );
      }
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: FutureBuilder<List<Evento>>(
        future: _eventosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar eventos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay eventos disponibles'));
          } else {
            List<Evento> eventos = snapshot.data!;

            return FlutterMap(
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
                    Marker(
                      point: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                      builder: (ctx) => Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                    ...eventos.map((evento) {
                      return Marker(
                        point: LatLng(evento.latitude ?? 0.0, evento.longitude ?? 0.0),
                        builder: (ctx) => GestureDetector(
                          onTap: () {
                            _showEventDetails(context, evento);
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
            );
          }
        },
      ),
    );
  }

  void _showEventDetails(BuildContext context, Evento evento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título del evento
                  Text(
                    evento.title ?? 'Evento sin nombre',
                    style: TextStyle(
                      fontSize: 20, // Cambio de headline6 a un tamaño más apropiado
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  // Imagen del evento
                  if (evento.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(evento.imageUrl!, fit: BoxFit.cover),
                    ),
                  SizedBox(height: 16),
                  // Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          // Aquí puedes agregar la funcionalidad de "Cómo llegar"
                        },
                        child: Text('Cómo llegar'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Cerrar'),
                        style: ElevatedButton.styleFrom(
                          // color del botón
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
