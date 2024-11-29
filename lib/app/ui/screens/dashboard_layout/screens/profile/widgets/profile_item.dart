part of '../screen.dart';

class _ProfileItem extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final String svgAssetIcon;
  const _ProfileItem(
      {required this.label,
      required this.onPressed,
      required this.svgAssetIcon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          SvgPicture.asset(svgAssetIcon,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
              colorFilter:
                  const ColorFilter.mode(AppUiColor.primary, BlendMode.srcIn)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          )),
          const Icon(CupertinoIcons.chevron_forward,
              size: 16, color: AppUiColor.primary)
        ],
      ),
    );
  }
}
