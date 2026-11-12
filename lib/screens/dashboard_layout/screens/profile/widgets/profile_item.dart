part of '../screen.dart';

class _ProfileItem extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final String? svgAssetIcon;
  final IconData? icon;

  const _ProfileItem({
    required this.label,
    required this.onPressed,
    this.svgAssetIcon,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, size: 20, color: AppUiColor.primary)
          else if (svgAssetIcon != null)
            SvgPicture.asset(
              svgAssetIcon!,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(AppUiColor.primary, BlendMode.srcIn),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
          const Icon(CupertinoIcons.chevron_forward,
              size: 16, color: AppUiColor.primary)
        ],
      ),
    );
  }
}
