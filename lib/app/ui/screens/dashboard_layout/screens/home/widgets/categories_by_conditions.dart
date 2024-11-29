part of '../screen.dart';

class _ProductConditionsHeader extends StatefulWidget {
  const _ProductConditionsHeader();

  @override
  State<_ProductConditionsHeader> createState() =>
      _ProductConditionsHeaderState();
}

class _ProductConditionsHeaderState extends State<_ProductConditionsHeader> {
  int _active = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _UsageCategory(
          name: "All",
          isActive: _active == 0,
          onPressed: () => _setActiveIndex(0),
        ),
        const SizedBox(width: 8),
        _UsageCategory(
            name: "Brand New",
            isActive: _active == 1,
            onPressed: () => _setActiveIndex(1)),
        const SizedBox(width: 8),
        _UsageCategory(
            name: "Used",
            isActive: _active == 2,
            onPressed: () => _setActiveIndex(2)),
        const SizedBox(width: 8),
        _UsageCategory(
            name: "Refurbished",
            isActive: _active == 3,
            onPressed: () => _setActiveIndex(3)),
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
    const constraints =
        BoxConstraints(minWidth: 66, maxHeight: 33, minHeight: 32.9);
    if (isActive) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          alignment: Alignment.center,
          constraints: constraints,
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
      child: Container(
        constraints: constraints,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppUiColor.borderline),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          name,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFC1C3CA)),
        ),
      ),
    );
  }
}
