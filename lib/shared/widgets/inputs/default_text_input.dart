import 'package:flutter/material.dart';

class DefaultTextInput extends StatelessWidget {
  const DefaultTextInput({
    super.key,
    required this.label,
    this.validator,
    this.controller,
    this.focusNode,
  });
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      validator: validator,
    );
  }
}
