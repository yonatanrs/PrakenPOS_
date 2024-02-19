import 'package:flutter/services.dart';

class QtyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newString = newValue.text;
    if (newString.trim().isEmpty) {
      newString = "1";
    }
    int selectionIndex = newString.length - newValue.selection.extentOffset;
    return TextEditingValue(
      text: newString.toString(),
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndex,
      ),
    );
  }
}