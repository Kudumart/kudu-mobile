import 'package:flutter/material.dart';

import '../../../colors.dart';

class PasswordTextFormField extends StatefulWidget {
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  const PasswordTextFormField(
      {this.onSaved, this.validator, this.onChanged, super.key});

  @override
  State<PasswordTextFormField> createState() => PasswordTextFormFieldState();
}

class PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      validator: widget.validator ?? _validate,
      autovalidateMode: AutovalidateMode.onUnfocus,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: 'Password',
        filled: true,
        hintStyle: const TextStyle(
            fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
        fillColor: AppUiColor.buttonFillGrey200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppUiColor.textBlue),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }

  String? _validate(String? input) {
    if (input == null || input.isEmpty) {
      return "Password is required";
    }
    if (input.length < 7) {
      return
          "Password must not be less than 7 characters";
    }
    return null;
  }
}
