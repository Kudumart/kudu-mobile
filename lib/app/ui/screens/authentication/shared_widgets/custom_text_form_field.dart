import 'package:flutter/material.dart';

import '../../../colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  const CustomTextFormField(
      {required this.hint, this.onSaved, this.validator, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: validator,
        autovalidateMode: AutovalidateMode.onUnfocus,
        onSaved: onSaved,
        decoration: InputDecoration(
          constraints: const BoxConstraints(minHeight: 47, maxHeight: 67),
          hintText: hint,
          hintStyle: const TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          filled: true,
          fillColor: AppUiColor.buttonFillGrey200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ));
  }
}
