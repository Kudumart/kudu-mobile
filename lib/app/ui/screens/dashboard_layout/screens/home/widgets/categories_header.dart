part of '../screen.dart';

class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Categories",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Text("See All",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: UiColor.primary))
      ],
    );
  }
}
