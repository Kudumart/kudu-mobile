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
    return SizedBox(
      height: 38,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return _UsageCategory(
            name: _getNameFromIndex(index),
            isActive: _active == index,
            onPressed: () => _setActiveIndex(index),
          );
        },
      ),
    );
  }

  _setActiveIndex(int index) {
    setState(
      () {
        _active = index;
      },
    );
  }

  String _getNameFromIndex(int index) {
    switch (index) {
      case 0:
        return "All";
      case 1:
        return "Brand New";
      case 2:
        return "Used";
      case 3:
        return "Refurbished";
      default:
        throw Exception("Invalid index");
    }
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
