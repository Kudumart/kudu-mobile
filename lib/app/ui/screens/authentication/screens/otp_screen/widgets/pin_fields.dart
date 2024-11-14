part of '../screen.dart';

class _OTPInput extends StatelessWidget {
  const _OTPInput();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PinCodeTextField(
        appContext: context,
        length: 5,
        enablePinAutofill: true,
        onChanged: (value) {},
        keyboardType: TextInputType.number,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          fieldHeight: 60,
          fieldWidth: 60,
          activeFillColor: UiColor.buttonFillGrey200,
          selectedFillColor: UiColor.buttonFillGrey200,
          inactiveFillColor: UiColor.buttonFillGrey200,
          selectedColor: UiColor.primary,
          activeColor: UiColor.buttonFillGrey200,
          inactiveColor: UiColor.buttonFillGrey200,
        ),
        cursorColor: Colors.grey,
        enableActiveFill: true,
      ),
    );
  }
}
