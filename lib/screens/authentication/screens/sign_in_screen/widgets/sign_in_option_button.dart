part of '../screen.dart';

class _SignInOptionButton extends StatelessWidget {
  final String svgAssetIcon;
  final String text;
  final Function() onPressed;
  const _SignInOptionButton(
      {required this.svgAssetIcon,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      icon: SvgPicture.asset(svgAssetIcon,
          height: 24, width: 24, fit: BoxFit.cover),
      text: text,
    );
  }
}
