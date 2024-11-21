import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:typed_data';
import 'dart:io';

class EmailService {
  Future<void> sendEmail({
    required String toEmail,
    required String subject,
    required String body,
    required Uint8List attachmentBytes,
    required String fileName,
  }) async {
    // Configuración del servidor SMTP
    final smtpServer = gmail('your_email@gmail.com', 'your_password'); // Usa tu correo y contraseña de aplicación

    // Crear el mensaje
    final message = Message()
      ..from = Address('your_email@gmail.com', 'Your Name') // Remitente
      ..recipients.add(toEmail) // Destinatario
      ..subject = subject
      ..text = body
      ..attachments = [
        FileAttachment(
          File.fromRawPath(attachmentBytes), // Convertir bytes a archivo
           // Nombre del archivo
        ),
      ];

    try {
      // Enviar el correo
      final sendReport = await send(message, smtpServer);
      print('Correo enviado: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Error al enviar correo: $e');
    }
  }
}
