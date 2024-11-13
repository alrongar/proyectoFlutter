import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintTextContent;
  final bool isPassword;
  final String? regularExpression;
  final bool isRequired;
  final String? regExpErrorMessage;

  const CustomTextField({
    super.key,
    this.hintTextContent = '',
    this.isPassword = false,
    this.regularExpression,
    this.isRequired = false,
    this.regExpErrorMessage,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController textController = TextEditingController();
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();

    final inputDecoration = InputDecoration(
      hintText: widget.hintTextContent,
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFC300)), // Amarillo en estado normal
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFD60A), width: 2), // Amarillo más claro al enfocar
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red), // Mantiene rojo en caso de error
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      hintStyle: const TextStyle(color: Colors.white), // Hint text en blanco
    );

    return TextFormField(
      controller: textController,
      focusNode: focusNode,
      decoration: inputDecoration,
      obscureText: widget.isPassword,
      validator: (value) {
        final validationResult = validateExpression(textFieldValue: value ?? '');
        setState(() {
          _isValid = validationResult == null;
        });
        return validationResult;
      },
      style: const TextStyle(color: Colors.white, fontSize: 18), // Texto en blanco
      maxLines: 1,
    );
  }

  String? validateExpression({required String textFieldValue}) {
    if (widget.isRequired && textFieldValue.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    if (widget.regularExpression != null && widget.regularExpression!.isNotEmpty) {
      final regex = RegExp(widget.regularExpression!);
      if (!regex.hasMatch(textFieldValue)) {
        return 'Entrada inválida';
      }
    }
    return null;
  }

  String get textValue => textController.value.text;

  bool get isValid => _isValid;
}
