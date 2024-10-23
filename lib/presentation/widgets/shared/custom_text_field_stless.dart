import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  final String hintTextContent;
  final bool isPassword;
  CustomTextField(
      {super.key, this.hintTextContent = '', this.isPassword = false});
  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final UnderlineInputBorder outlineInputBorder = UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));
    final inputDecoration = InputDecoration(
      hintText: hintTextContent,
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
      obscureText: isPassword,
    );
  }
  String get textValue => textController.value.text;
}