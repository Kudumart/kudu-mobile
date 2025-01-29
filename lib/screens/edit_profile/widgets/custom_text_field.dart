part of '../screen.dart';

class _CustomTextFormField extends StatelessWidget {
  final String hint;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function()? onTap;
  final bool? enabled;
  final Widget? suffixIcon;
  final TextEditingController controller;
  const _CustomTextFormField({
    required this.hint,
    this.enabled,
    this.onTap,
    this.suffixIcon,
    this.onSaved,
    this.validator,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onTap: onTap,
        controller: controller,
        enabled: enabled,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: onSaved,
        decoration: InputDecoration(
          constraints: const BoxConstraints(minHeight: 47, maxHeight: 67),
          hintText: hint,
          hintStyle: const TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          filled: true,
          fillColor: AppUiColor.buttonFillGrey200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
          ),
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ));
  }
}
