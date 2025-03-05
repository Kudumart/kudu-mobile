part of '../screen.dart';

class _ProductConditions extends StatefulWidget {
  const _ProductConditions({this.active = -1, this.onSelected});
  final int active;
  final Function(int)? onSelected;

  @override
  State<_ProductConditions> createState() => _ProductConditionsState();
}

class _ProductConditionsState extends State<_ProductConditions> {

  @override
  Widget build(BuildContext context) {
    var status = ProductCondition.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...status.map((e) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _UsageCategory(
                  name: e.printableName(),
                  isActive: widget.active == status.indexOf(e),
                  onPressed: () => _setActiveIndex(status.indexOf(e))),
            );
          },),
        ],
      ),
    );
  }

  _setActiveIndex(int index) {
    widget.onSelected?.call(index);
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
      return GestureDetector(
        onTap: onPressed,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            alignment: Alignment.center,
            constraints: constraints,
            decoration: BoxDecoration(
                color: AppUiColor.primary,
                borderRadius: BorderRadius.circular(5)),
            child: Text(name,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white))),
      );
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
