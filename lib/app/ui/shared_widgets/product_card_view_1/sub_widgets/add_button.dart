part of '../product_card_view_1.dart';


class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 31,
      width: 31,
      decoration: const BoxDecoration(
          color: AppUiColor.primary, shape: BoxShape.circle),
      child: const Icon(CupertinoIcons.add, color: Colors.white, size: 18),
    );
  }
}