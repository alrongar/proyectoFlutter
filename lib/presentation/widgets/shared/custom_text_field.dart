import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintTextContent;
  final bool isPassword;
  final String? regularExpression;

  CustomTextField({
    super.key,
    this.hintTextContent = '',
    this.isPassword = false,
    this.regularExpression,
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
    final UnderlineInputBorder outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    final inputDecoration = InputDecoration(
      hintText: widget.hintTextContent,
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
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
        final validationResult = validateExpression(textFieldValue: value ?? '');
        setState(() {
          _isValid = validationResult == null;
        });
        return validationResult;
      },
    );
  }

  String? validateExpression({required String textFieldValue}) {
    if (widget.regularExpression != null && widget.regularExpression!.isNotEmpty) {
      final regex = RegExp(widget.regularExpression!);
      if (!regex.hasMatch(textFieldValue)) {
        return 'Invalid input';
      }
    }
    return null;
  }

  String get textValue => textController.value.text;
  
  bool get isValid => _isValid;
}
