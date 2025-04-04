import 'package:flutter/material.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/core/colors.dart';

class ProductConditionBanner extends StatelessWidget {
  final ProductCondition status;
  const ProductConditionBanner(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 69,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: _backgroundColor()),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          status.printableName(),
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w400, color: _textColor()),
        ),
      ),
    );
  }

  Color _backgroundColor() {
    switch (status) {
      case ProductCondition.fairlyforeign:
        return const Color(0xFFFF0F00);
      case ProductCondition.fairlyused:
        return const Color.fromARGB(255, 238, 190, 15);
      case ProductCondition.brandNew:
        return const Color(0xFF34A853);
      case ProductCondition.refurbished:
        return const Color.fromARGB(255, 232, 170, 78);
      }
  }

  Color _textColor() {
    switch (status) {
      case ProductCondition.fairlyforeign:
        return Colors.black;
      case ProductCondition.fairlyused:
        return Colors.black;
      case ProductCondition.brandNew:
        return Colors.white;
      case ProductCondition.refurbished:
        return Colors.black;
      }
  }
}
