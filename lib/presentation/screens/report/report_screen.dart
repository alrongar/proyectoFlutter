import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../providers/event_service.dart';
import '../../../models/event.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedCategories = [];
  final List<String> _categories = ['Music', 'Sport', 'Technology'];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _generatePDF() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Fetch events based on the selected criteria
      List<Evento> events = await EventServices().fetchEventos();
      events = events.where((event) {
        bool matchesDate = true;
        bool matchesCategory = _selectedCategories.contains(event.category);
        if (_startDate != null) {
          matchesDate = matchesDate && event.startTime.isAfter(_startDate!);
        }
        if (_endDate != null) {
          matchesDate = matchesDate && event.startTime.isBefore(_endDate!);
        }
        return matchesDate && matchesCategory;
      }).toList();

      // Generate PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: events.map((event) {
                return pw.Text('${event.title} - ${DateFormat('dd/MM/yyyy').format(event.startTime)}');
              }).toList(),
            );
          },
        ),
      );

      // Save PDF to internal storage
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/report.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF generado y guardado en ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: Text('Fecha de inicio: ${_startDate != null ? DateFormat('dd/MM/yyyy').format(_startDate!) : 'No seleccionada'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text('Fecha final: ${_endDate != null ? DateFormat('dd/MM/yyyy').format(_endDate!) : 'No seleccionada'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              ..._categories.map((category) {
                return CheckboxListTile(
                  title: Text(category),
                  value: _selectedCategories.contains(category),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generatePDF,
                child: Text('Generar PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}