import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../../../models/category.dart';
import '../../../providers/event_service.dart';

class EditEventScreen extends StatefulWidget {
  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late Evento _evento;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _latitudeController = TextEditingController(text: '0.0');
  final _longitudeController = TextEditingController(text: '0.0');
  final _maxAttendeesController = TextEditingController(text: '0');
  final _latitudeStringController = TextEditingController();
  final _longitudeStringController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  String? _selectedCategory;
  late Future<List<Category>> _categoriesFuture;
  bool _isDataLoaded = false; // Bandera para controlar la carga de datos

  @override
  void initState() {
    super.initState();
    _categoriesFuture = EventServices().fetchCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataLoaded) {
      _evento = ModalRoute.of(context)!.settings.arguments as Evento;
      _titleController.text = _evento.title;
      _descriptionController.text = _evento.description;
      _locationController.text = _evento.location ?? ''; // Asegurarse de asignar la ubicación correctamente
      _priceController.text = _evento.price.toString();
      _imageUrlController.text = _evento.imageUrl ?? '';
      _startTime = _evento.startTime;
      _endTime = _evento.endTime;
      _latitudeController.text = _evento.latitude.toString();
      _longitudeController.text = _evento.longitude.toString();
      _maxAttendeesController.text = _evento.maxAttendees.toString();
      _selectedCategory = _evento.categoryid.toString(); // Asignar el ID de la categoría directamente
      _latitudeStringController.text = _evento.latitudeString ?? _evento.latitude?.toString() ?? '';
      _longitudeStringController.text = _evento.longitudeString ?? _evento.longitude?.toString() ?? '';
      _isDataLoaded = true; // Marcar los datos como cargados
    }
  }

  Future<void> _editEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedEvent = Evento(
        id: _evento.id,
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        organizerId: _evento.organizerId,
        category: _selectedCategory,
        categoryid: int.tryParse(_selectedCategory ?? '0') ?? 1,
        startTime: _startTime!,
        endTime: _endTime,
        location: _locationController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        deleted: _evento.deleted,
        latitude: double.tryParse(_latitudeController.text) ?? 0.0,
        longitude: double.tryParse(_longitudeController.text) ?? 0.0,
        maxAttendees: int.tryParse(_maxAttendeesController.text) ?? 0,
        latitudeString: _latitudeStringController.text,
        longitudeString: _longitudeStringController.text,
      );

      bool success = await EventServices().updateEvent(updatedEvent);

      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo actualizar el evento.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce una ubicación';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un precio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL de la imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce una URL de imagen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Latitud'),
              ),
              TextFormField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Longitud'),
              ),
              TextFormField(
                controller: _maxAttendeesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Máximo de asistentes'),
              ),
              TextFormField(
                controller: _latitudeStringController,
                decoration: const InputDecoration(labelText: 'Latitud'),
              ),
              TextFormField(
                controller: _longitudeStringController,
                decoration: const InputDecoration(labelText: 'Longitud'),
              ),
              ListTile(
                title: const Text('Fecha de inicio'),
                subtitle: Text(_startTime != null ? _startTime.toString() : 'Selecciona una fecha'),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _startTime ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _startTime = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Fecha de fin'),
                subtitle: Text(_endTime != null ? _endTime.toString() : 'Selecciona una fecha'),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _endTime ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _endTime = picked;
                    });
                  }
                },
              ),
              FutureBuilder<List<Category>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error al cargar categorías');
                  } else if (snapshot.hasData) {
                    List<Category> categories = snapshot.data!;
                    if (categories.isEmpty) {
                      return const Text('No hay categorías disponibles');
                    }

                    // Si no existe exactamente una categoría con el valor seleccionado, 
                    // seleccionamos la primera (para evitar la excepción).
                    final uniqueIds = categories.map((c) => c.id.toString()).toSet();
                    if (_selectedCategory == null || !uniqueIds.contains(_selectedCategory)) {
                      _selectedCategory = categories.first.id.toString();
                    }

                    return DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: categories.map((Category category) {
                        return DropdownMenuItem<String>(
                          value: category.id.toString(),
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecciona una categoría';
                        }
                        return null;
                      },
                    );
                  } else {
                    return const Text('No hay categorías disponibles');
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editEvent,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}