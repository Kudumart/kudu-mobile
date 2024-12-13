part of 'overlay.dart';

class _CustomErrorDialog extends StatelessWidget {
  final String? title;
  final String info;
  final Function()? onPressedOkayButton;
  final String? okayButtonText;
  const _CustomErrorDialog(
      {this.title,
      required this.info,
      this.onPressedOkayButton,
      this.okayButtonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // checkmark
        SvgPicture.asset(
          AppUiIcon.error,
          height: 72,
          width: 72,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 15),

        // title
        Text(
          title == null ? "Error" : title!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),

        // body
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            info,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 47,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
              onPressed: onPressedOkayButton,
              child: Text(
                okayButtonText ?? "Okay",
              )),
        ),
      ],
    );
  }
}
