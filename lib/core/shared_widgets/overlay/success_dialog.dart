part of 'overlay.dart';

class _CustomSuccessDialog extends StatelessWidget {
  final String? title;
  final String info;
  final Function() onPressedOkayButton;
  final String? okayButtonText;
  const _CustomSuccessDialog({
    this.title,
    required this.info,
    required this.onPressedOkayButton,
    this.okayButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // checkmark
        SvgPicture.asset(
          AppUiIcon.greenRoundCheckmark,
          height: 72,
          width: 72,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 30),

        // title
        Text(
          title == null ? "Success" : title!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),

        // body
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            info,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 25),

        // okay button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AppButton(
            text: okayButtonText ?? "Okay",
            onPressed: onPressedOkayButton,
            variant: AppButtonVariant.primary,
          ),
        )
      ],
    );
  }
}
