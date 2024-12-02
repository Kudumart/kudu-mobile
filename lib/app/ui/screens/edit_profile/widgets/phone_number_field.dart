part of '../screen.dart';

class _IntlPhoneNumberField extends StatefulWidget {
  final Function(PhoneNumber?) onSaved;
  final String? initialCompletePhoneNumber;
  const _IntlPhoneNumberField({
    required this.onSaved,
    required this.initialCompletePhoneNumber,
  });

  @override
  State<_IntlPhoneNumberField> createState() => _IntlPhoneNumberFieldState();
}

class _IntlPhoneNumberFieldState extends State<_IntlPhoneNumberField> {
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
      initialCountryCode: _initialCountryCode,
      initialValue: _initialNumber,
      autovalidateMode: AutovalidateMode.onUnfocus,
      flagsButtonPadding: const EdgeInsets.fromLTRB(8, 5, 10, 5),
      flagsButtonMargin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      decoration: InputDecoration(
          constraints: const BoxConstraints(minHeight: 47, maxHeight: 67),
          hintText: "Enter phone number",
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
