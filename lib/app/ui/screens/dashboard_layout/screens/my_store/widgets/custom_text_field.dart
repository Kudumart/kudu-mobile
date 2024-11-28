part of '../screen.dart';

class _CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final Function(String?) onSaved;
  final String? Function(String?) validator;
  const _CustomTextField(
      {required this.label,
      required this.validator,
      required this.hint,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: const BorderSide(color: Color(0xFFD2D2D2)),
    );
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        constraints: const BoxConstraints(minHeight: 58, maxHeight: 75),
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppUiColor.iconBlack),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      ),
      style: const TextStyle(
          color: AppUiColor.iconBlack,
          fontSize: 14,
          fontWeight: FontWeight.w500),
    );
  }
}
