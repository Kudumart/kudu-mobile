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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _UsageCategory(
            name: "All",
            isActive: _active == 0,
            onPressed: () => _setActiveIndex(0),
          ),
          const SizedBox(width: 15),
          _UsageCategory(
              name: "Brand New",
              isActive: _active == 1,
              onPressed: () => _setActiveIndex(0)),
          const SizedBox(width: 15),
          _UsageCategory(
              name: "Used",
              isActive: _active == 2,
              onPressed: () => _setActiveIndex(0)),
          const SizedBox(width: 15),
          _UsageCategory(
              name: "Refurbished",
              isActive: _active == 2,
              onPressed: () => _setActiveIndex(0)),
        ],
      ),
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
              color: AppUiColor.primary,
              borderRadius: BorderRadius.circular(5)),
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
