part of '../screen.dart';

class _ProgressIndicator extends StatelessWidget {
  final int activeIndex;
  const _ProgressIndicator({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Indicator(isActive: activeIndex == 0),
        const SizedBox(width: 5),
        _Indicator(isActive: activeIndex == 1),
        const SizedBox(width: 5),
        _Indicator(isActive: activeIndex == 2),
      ],
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
          color: isActive ? AppColor.primary : const Color(0xFFF5DED1)),
      duration: const Duration(milliseconds: 500),
    );
  }
}
