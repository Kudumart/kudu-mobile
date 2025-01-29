part of '../screen.dart';

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: const Color(0xFFF4F4F4)),
      child: SvgPicture.asset(
        AppUiIcon.cartFilled,
      ),
    );
  }
}
