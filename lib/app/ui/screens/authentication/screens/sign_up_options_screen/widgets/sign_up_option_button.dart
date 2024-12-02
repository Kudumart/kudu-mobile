part of '../screen.dart';

class _SignUpOptionButton extends StatelessWidget {
  final String svgAssetIcon;
  final String text;
  final Function() onPressed;
  const _SignUpOptionButton(
      {required this.svgAssetIcon,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppUiColor.buttonFillGrey200,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgAssetIcon,
                height: 24, width: 24, fit: BoxFit.cover),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
