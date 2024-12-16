import 'package:flutter/material.dart';
import '../../../models/event.dart';
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
  DateTime? _startTime;
  DateTime? _endTime;
  String? _selectedCategory;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _evento = ModalRoute.of(context)!.settings.arguments as Evento;
    _titleController.text = _evento.title;
    _descriptionController.text = _evento.description;
    _locationController.text = _evento.location ?? '';
    _startTime = _evento.startTime;
    _endTime = _evento.endTime;
    _selectedCategory = _evento.category;
  }

  Future<void> _editEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedEvent = Evento(
        id: _evento.id,
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _evento.imageUrl,
        organizerId: _evento.organizerId,
        category: _selectedCategory,
        categoryid: _evento.categoryid,
        startTime: _startTime!,
        endTime: _endTime,
        location: _locationController.text,
        price: _evento.price, // Add the required 'price' parameter
      );

      try {
        await EventServices().updateEvent(updatedEvent);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al editar el evento: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Ubicación'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce una ubicación';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Fecha de inicio'),
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
                title: Text('Fecha de fin'),
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
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Music', 'Sport', 'Technology'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona una categoría';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editEvent,
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}