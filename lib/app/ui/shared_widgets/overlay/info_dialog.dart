part of 'overlay.dart';

class _CustomInfoDialog extends StatelessWidget {
  final String title;
  final String info;
  const _CustomInfoDialog({
    required this.title,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // checkmark
        SvgPicture.asset(
          AppUiIcon.infoAlt,
          height: 72,
          width: 72,
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
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
      ],
    );
  }
}
