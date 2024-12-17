import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../../../models/category.dart';
import '../../../providers/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  String? _selectedCategory;
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = EventServices().fetchCategories();
  }

  Future<void> _createEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = int.parse(prefs.getString('user_id') ?? '0');

      final newEvent = Evento(
        id: 0, // El ID será asignado por el backend
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        organizerId: userId, // ID del organizador
        category: _selectedCategory,
        categoryid: int.tryParse(_selectedCategory ?? '0'),
        startTime: _startTime!,
        endTime: _endTime,
        location: _locationController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
      );

      try {
        // Crear el evento
        await EventServices().createEvent(newEvent);

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el evento: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Evento'),
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
              ListTile(
                title: const Text('Fecha de inicio'),
                subtitle: Text(_startTime != null ? _startTime.toString() : 'Selecciona una fecha'),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
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
                    initialDate: DateTime.now(),
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
                onPressed: _createEvent,
                child: const Text('Crear Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}