part of '../screen.dart';

class _UsageCategories extends StatefulWidget {
  const _UsageCategories();

  @override
  State<_UsageCategories> createState() => _UsageCategoriesState();
}

class _UsageCategoriesState extends State<_UsageCategories> {
  int _active = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _UsageCategory(
          name: "All Products",
          isActive: _active == 0,
          onPressed: () => _setActiveIndex(0),
        ),
        _UsageCategory(
            name: "Brand New Products",
            isActive: _active == 1,
            onPressed: () => _setActiveIndex(0)),
        _UsageCategory(
            name: "Used Products",
            isActive: _active == 2,
            onPressed: () => _setActiveIndex(0)),
      ],
    );
  }

  _setActiveIndex(int index) {
    setState(() => _active = index);
  }
}

class _UsageCategory extends StatelessWidget {
  final String name;
  final bool isActive;
  final Function() onPressed;
  const _UsageCategory(
      {required this.name, required this.onPressed, required this.isActive});

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: UiColor.primary, borderRadius: BorderRadius.circular(5)),
          child: Text(name,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)));
    }
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        name,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFC1C3CA)),
      ),
    );
  }
}
