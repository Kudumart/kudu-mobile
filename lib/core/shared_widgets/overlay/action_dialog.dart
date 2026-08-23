part of 'overlay.dart';

class _CustomActionDialog extends StatelessWidget {
  final String title;
  final String info;
  final Function() onPressedOkayButton;
  final Function() onPressedCancelButton;
  final String? okayButtonText;
  const _CustomActionDialog({
    required this.title,
    required this.info,
    required this.onPressedCancelButton,
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
          title,
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: "Cancel",
                onPressed: onPressedCancelButton,
                variant: AppButtonVariant.text,
                isFullWidth: false,
              ),
              const SizedBox(width: 12),
              AppButton(
                text: okayButtonText ?? "Okay",
                onPressed: onPressedOkayButton,
                variant: AppButtonVariant.primary,
                isFullWidth: false,
              ),
            ],
          ),
        )
      ],
    );
  }
}
