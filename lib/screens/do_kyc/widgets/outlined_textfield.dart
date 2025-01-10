part of '../screen.dart';

class _CustomOutlinedTextField extends StatelessWidget {
  final String label;
  final String hint;
  final Function(String?)? onSaved;
  final String? Function(String?) validator;
  final int? maxLines;
  final TextEditingController controller;

  const _CustomOutlinedTextField({
    required this.label,
    required this.validator,
    required this.hint,
    this.maxLines,
    this.onSaved,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: const BorderSide(color: Color(0xFFD2D2D2)),
    );
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUnfocus,
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      maxLines: maxLines,
      decoration: InputDecoration(
        constraints: BoxConstraints(
            minHeight: 58, maxHeight: maxLines == null ? 75 : 130),
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
            fontSize: 13,
            color: AppUiColor.iconBlack,
            fontWeight: FontWeight.w400),
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
