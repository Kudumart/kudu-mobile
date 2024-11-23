part of 'overlay.dart';

class _CustomInfoDialog extends StatelessWidget {
  final String title;
  final String info;
  final Function() onPressedOkayButton;
  final Function() onPressedCancelButton;
  final String? okayButtonText;
  const _CustomInfoDialog({
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
              TextButton(
                  onPressed: onPressedCancelButton,
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppUiColor.iconBlack),
                  )),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onPressedOkayButton,
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppUiColor.primary,
                  ),
                  child: Text(
                    okayButtonText == null ? "Okay" : okayButtonText!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
