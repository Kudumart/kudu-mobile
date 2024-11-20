part of '../screen.dart';

class _OTPInput extends StatelessWidget {
  final void Function(String?)? onSaved;
  final Function(String) onCompleted;
  const _OTPInput({required this.onSaved, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: PinCodeTextField(
        appContext: context,
        validator: _validateCode,
        onSaved: onSaved,
        length: 6,
        onCompleted: onCompleted,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        enablePinAutofill: true,
        keyboardType: TextInputType.number,
        pinTheme: PinTheme(
          fieldHeight: 50,
          fieldWidth: _calculateFieldWidth(context),
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          activeFillColor: AppUiColor.buttonFillGrey200,
          selectedFillColor: AppUiColor.buttonFillGrey200,
          inactiveFillColor: AppUiColor.buttonFillGrey200,
          selectedColor: AppUiColor.primary,
          activeColor: AppUiColor.buttonFillGrey200,
          inactiveColor: AppUiColor.buttonFillGrey200,
        ),
        cursorColor: Colors.grey,
        enableActiveFill: true,
      ),
    );
  }

  String? _validateCode(String? input) {
    if (input == null || input.length < 6) {
      return "Invalid code";
    }

    return null;
  }

  double _calculateFieldWidth(BuildContext context) {
    const int numberOfPinFields = 6;
    const double minSpaceBetweenFields = 8;
    const double horizontalPaddingOnPinPutFields = 10;
    final double availableWidth = MediaQuery.sizeOf(context).width -
        (UiConstant.horizontalPadding * 2) -
        (horizontalPaddingOnPinPutFields * 2) -
        (minSpaceBetweenFields * numberOfPinFields);
    if (availableWidth / numberOfPinFields >= 50) {
      return 50;
    }
    return 45;
  }
}
