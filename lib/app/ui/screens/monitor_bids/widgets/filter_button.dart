part of '../screen.dart';

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 28,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: AppUiColor.primary),
          borderRadius: BorderRadius.circular(3.7)),
      child: SvgPicture.asset(
        AppUiIcon.filter,
        height: 20,
        width: 20,
        fit: BoxFit.cover,
      ),
    );
  }
}
