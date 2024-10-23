import 'package:flutter/material.dart';

class CustomTextFieldStful extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  final String hintTextContent;
  final bool isPassword;
  final bool isRequired;

  CustomTextFieldStful({
    super.key,
    this.hintTextContent = '',
    this.isPassword = false,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final UnderlineInputBorder outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    final inputDecoration = InputDecoration(
      hintText: hintTextContent,
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
      obscureText: isPassword,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
    );
  }

  String get textValue => textController.value.text;
}