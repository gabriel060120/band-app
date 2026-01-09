import 'package:flutter/services.dart';

class HourInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        formatted += ':';
      }
      formatted += text[i];
    }

    if (text.length >= 2) {
      final hours = int.parse(text.substring(0, 2));
      if (hours > 23) {
        return oldValue;
      }
    }

    if (text.length >= 4) {
      final minutes = int.parse(text.substring(2, 4));
      if (minutes >= 60) {
        return oldValue;
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
