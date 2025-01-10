import 'package:flutter/material.dart';
import 'package:kudu/core/colors.dart';

import '../constants.dart';

class CustomDivider extends StatelessWidget {
  final bool withoutMargin;
  const CustomDivider({this.withoutMargin = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: withoutMargin ? null : const EdgeInsets.symmetric(
            horizontal: UiConstant.horizontalPadding),
        color: AppUiColor.borderline,
        height: 1);
  }
}
