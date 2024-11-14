part of '../screen.dart';

class _UsageCategories extends StatelessWidget {
  const _UsageCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _UsageCategory(name: "All Products", isActive: true),
          SizedBox(width: 25),
          _UsageCategory(name: "Brand New Products", isActive: false),
          SizedBox(width: 25),
          _UsageCategory(name: "Used Products", isActive: false),
        ],
      ),
    );
  }
}

class _UsageCategory extends StatelessWidget {
  final String name;
  final bool isActive;
  const _UsageCategory({required this.name, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isActive ? UiColor.primary : const Color(0xFFC1C3CA)),
    );
  }
}
