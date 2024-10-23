import 'package:flutter/material.dart';

class CustomTextFieldStful extends StatefulWidget {
  final String hintTextContent;
  final bool isPassword;
  final String? regularExpression;
  final bool isRequired;
  final String? regExpErrorMessage;

  const CustomTextFieldStful(
      {super.key,
      this.hintTextContent = '',
      this.isPassword = false,
      this.regularExpression,
      this.isRequired = false,
      this.regExpErrorMessage});

  @override
  CustomTextFieldStfulState createState() => CustomTextFieldStfulState();
}

class CustomTextFieldStfulState extends State<CustomTextFieldStful> {
  final TextEditingController textController = TextEditingController();
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final UnderlineInputBorder outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    final inputDecoration = InputDecoration(
      hintText: widget.hintTextContent,
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      errorBorder: outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.red),
      ),
      filled: true,
    );

    return TextFormField(
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      focusNode: focusNode,
      controller: textController,
      decoration: inputDecoration,
      obscureText: widget.isPassword,
      validator: (value) {
        final validationResult =
            validateExpression(textFieldValue: value ?? '');
        setState(() {
          _isValid = validationResult == null;
        });
        return validationResult;
      },
    );
  }

  String? validateExpression({required String textFieldValue}) {
    if (widget.isRequired && textFieldValue.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    if (widget.regularExpression != null &&
        widget.regularExpression!.isNotEmpty) {
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
