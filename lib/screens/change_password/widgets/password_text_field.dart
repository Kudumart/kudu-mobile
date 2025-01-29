part of '../screen.dart';

class _PasswordTextFormField extends StatefulWidget {
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final String hint;
  final String? Function(String?)? validator;
  const _PasswordTextFormField(
      {this.onSaved,
      required this.hint,
      this.validator,
      this.onChanged});

  @override
  State<_PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<_PasswordTextFormField> {
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
        hintText: widget.hint,
        filled: true,
        hintStyle: const TextStyle(
            fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
        fillColor: AppUiColor.grey50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),

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
      return "Password must not be less than 7 characters";
    }
    return null;
  }
}
