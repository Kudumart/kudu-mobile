part of '../screen.dart';

class _IntlPhoneNumberField extends StatelessWidget {
  final Function(PhoneNumber?) onSaved;
  const _IntlPhoneNumberField({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      initialCountryCode: "US",
      pickerDialogStyle: PickerDialogStyle(backgroundColor: Colors.white),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blue),
          )),
      dropdownDecoration: BoxDecoration(
          border: Border.all(color: AppUiColor.borderline),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
      invalidNumberMessage: "Invalid phone number",
      showCountryFlag: false,
      onSaved: onSaved,
    );
  }
}
