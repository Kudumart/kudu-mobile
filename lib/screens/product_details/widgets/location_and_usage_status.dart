part of '../screen.dart';

class _LocationAndProductConditionView extends StatelessWidget {
  final String location;
  const _LocationAndProductConditionView({required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppUiIcon.location,
          height: 16,
          width: 16,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(Color(0xFF5F5F5F), BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            location,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF5F5F5F),
            ),
          ),
        ),
      ],
    );
  }
}
