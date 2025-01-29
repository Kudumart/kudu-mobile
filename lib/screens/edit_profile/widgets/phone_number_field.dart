part of '../screen.dart';

class IntlPhoneNumberField extends StatefulWidget {
  final Function(PhoneNumber?) onSaved;
  final bool enabled;
  final String? initialCompletePhoneNumber;
  final String? hintText;
  final Function(PhoneNumber)? onChanged;
  const IntlPhoneNumberField({
    required this.onSaved,
    required this.initialCompletePhoneNumber,
    this.enabled = true,
    this.hintText,
    this.onChanged,
  });

  @override
  State<IntlPhoneNumberField> createState() => _IntlPhoneNumberFieldState();
}

class _IntlPhoneNumberFieldState extends State<IntlPhoneNumberField> {
  String? _initialNumber;
  String? _initialCountryCode;

  @override
  void initState() {
    super.initState();
    if (widget.initialCompletePhoneNumber != null) {
      final phoneNumber = PhoneNumber.fromCompleteNumber(
          completeNumber: widget.initialCompletePhoneNumber!);
      _initialCountryCode = phoneNumber.countryCode;
      _initialNumber = phoneNumber.number;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      initialCountryCode: "NG",
      initialValue: _initialNumber,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      autovalidateMode: AutovalidateMode.onUnfocus,
      flagsButtonPadding: const EdgeInsets.fromLTRB(8, 5, 10, 5),
      flagsButtonMargin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      decoration: InputDecoration(
          constraints: const BoxConstraints(minHeight: 47, maxHeight: 67),
          hintText: widget.hintText ?? "Enter phone number",
          hintStyle: const TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          filled: true,
          fillColor: AppUiColor.buttonFillGrey200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: const BorderSide(color: Colors.blue),
          )),
      dropdownDecoration: BoxDecoration(
          border: Border.all(color: AppUiColor.borderline),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
      invalidNumberMessage: "Invalid phone number",
      showCountryFlag: true,
      onSaved: widget.onSaved,
    );
  }
}
