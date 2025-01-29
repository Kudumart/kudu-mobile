import 'package:flutter/material.dart';

import '../colors.dart';

class DottedProgressIndicator extends StatelessWidget {
  final int activeIndex;
  final int count;
  const DottedProgressIndicator({
    required this.activeIndex,
    required this.count, super.key
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> separatedDots = [];
    for (int i = 0; i < count; i++) {
      separatedDots.add(_Indicator(isActive: activeIndex == i));
      if (i < count - 1) {
        separatedDots.add(const SizedBox(width: 5));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: separatedDots,
    );
  }
}

class _Indicator extends StatelessWidget {
  final bool isActive;
  const _Indicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isActive ? 25 : 7,
      height: 7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isActive ? AppUiColor.primary : const Color(0xFFF5DED1)),
      duration: const Duration(milliseconds: 500),
    );
  }
}
