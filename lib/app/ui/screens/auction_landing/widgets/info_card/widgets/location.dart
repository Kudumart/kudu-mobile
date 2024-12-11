part of '../../../screen.dart';

class _Location extends StatelessWidget {
  final String location;
  const _Location(this.location);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AppUiIcon.location,
            colorFilter:
                const ColorFilter.mode(AppUiColor.primary, BlendMode.srcIn),
            height: 14,
            width: 14,
            fit: BoxFit.contain),
        const SizedBox(width: 5),
        Text(
          _shortenLocation(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppUiColor.iconBlack),
        ),
      ],
    );
  }

  String _shortenLocation() {
    if (location.length > 21) {
      return "${location.substring(0, 21)}...";
    }
    return location;
  }
}
