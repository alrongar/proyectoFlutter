import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import 'dart:typed_data';
import '../../../providers/event_service.dart';
import '../../../models/event.dart';
import '../../../models/category.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  Future<void> sendEmail({
    required String toEmail,
    required String subject,
    required String body,
    required Uint8List attachmentBytes,
    required String fileName,
  }) async {
    final smtpServer = gmail('cistianlr@gmail.com', '11022003'); // Usa tu correo y contraseña de aplicación

    final message = Message()
      ..from = Address('cistianlr@gmail.com', 'Cris') // Remitente
      ..recipients.add(toEmail) // Destinatario
      ..subject = subject
      ..text = body
      ..attachments = [
        FileAttachment(
          File.fromRawPath(attachmentBytes), // Convertir bytes a archivo

        ),
      ];

    try {
      final sendReport = await send(message, smtpServer);
      print('Correo enviado: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Error al enviar correo: $e');
    }
  }
}

class ReportScreen extends StatefulWidget {
  final String email;
  const ReportScreen({super.key, required this.email});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _selectedCategories = [];
  List<Category> _categories = [];
  
  get email => null;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> categories = await EventServices().fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar las categorías')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year), // Usar el año actual
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

  Future<String> _getDownloadDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      directory = await path_provider.getApplicationDocumentsDirectory();
    } else {
      directory = await path_provider.getDownloadsDirectory();
    }
    return directory?.path ?? '';
  }

  Future<File?> _generatePDF() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, seleccione las fechas de inicio y fin')),
      );
      return null;
    }

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

      // Verificar si hay eventos
      if (events.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'No hay eventos que cumplan con los criterios seleccionados')),
        );
        return null;
      }

      // Generate PDF
      final pdf = pw.Document();
      final List<pw.Widget> eventWidgets = [];
      for (var event in events) {
        final image = pw.MemoryImage(
          (await NetworkAssetBundle(Uri.parse(event.imageUrl))
                  .load(event.imageUrl))
              .buffer
              .asUint8List(),
        );
        eventWidgets.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(image, width: 100, height: 100),
              pw.Text(event.title,
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                  '${DateFormat('dd/MM/yyyy').format(event.startTime)} - ${DateFormat('dd/MM/yyyy').format(event.startTime)}'),
              pw.SizedBox(height: 10),
            ],
          ),
        );
      }
      pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Column(children: eventWidgets)));

      // Save PDF to Download directory
      final directory = await _getDownloadDirectory();
      final file = File('$directory/report.pdf');
      await file.writeAsBytes(await pdf.save());

      if (await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pdf generado correctamente en ${file.path}')),
        );
        return file; // Devuelve el archivo si todo fue bien
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al generar el pdf')),
        );
        return null;
      }
    }
    return null;
  }

  

  Future<void> _sendEmail(String pdfFilePath) async {
    final emailService = EmailService();
    final file = File(pdfFilePath);
    final fileBytes = await file.readAsBytes();
    await emailService.sendEmail(
      toEmail: email,  // Dirección de correo del destinatario
      subject: 'Informe de eventos',
      body: 'Adjunto el informe generado en formato PDF.',
      attachmentBytes: fileBytes,
      fileName: 'informe_eventos.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: Text(
                    'Fecha de inicio: ${_startDate != null ? DateFormat('dd/MM/yyyy').format(_startDate!) : 'No seleccionada'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text(
                    'Fecha final: ${_endDate != null ? DateFormat('dd/MM/yyyy').format(_endDate!) : 'No seleccionada'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              ..._categories.map((category) {
                return CheckboxListTile(
                  title: Text(category.name),
                  value: _selectedCategories.contains(category.name),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedCategories.add(category.name);
                      } else {
                        _selectedCategories.remove(category.name);
                      }
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _generatePDF,
                    child: const Text('Generar PDF'),
                  ),
                  
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_startDate == null || _endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, seleccione las fechas de inicio y fin')),
                    );
                    return;
                  }
                      print(email);

                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

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

                    if (events.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No hay eventos que cumplan con los criterios seleccionados')),
                      );
                      return;
                    }

                    final pdf = pw.Document();
                    final List<pw.Widget> eventWidgets = [];
                    for (var event in events) {
                      final image = pw.MemoryImage(
                        (await NetworkAssetBundle(Uri.parse(event.imageUrl)).load(event.imageUrl)).buffer.asUint8List(),
                      );
                      eventWidgets.add(
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Image(image, width: 100, height: 100),
                            pw.Text(event.title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                            pw.Text('${DateFormat('dd/MM/yyyy').format(event.startTime)} - ${DateFormat('dd/MM/yyyy').format(event.startTime)}'),
                            pw.SizedBox(height: 10),
                          ],
                        ),
                      );
                    }
                    pdf.addPage(pw.Page(build: (pw.Context context) => pw.Column(children: eventWidgets)));

                    final directory = await _getDownloadDirectory();
                    final file = File('$directory/report.pdf');
                    await file.writeAsBytes(await pdf.save());

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('PDF generado y guardado en ${file.path}')),
                    );

                    await _sendEmail(file.path);
                  }
                },
                child: const Text('Generar y enviar por correo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
