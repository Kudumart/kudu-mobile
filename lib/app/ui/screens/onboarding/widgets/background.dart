part of '../screen.dart';

class _Rings extends StatelessWidget {
  const _Rings();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final big = Size(constraints.maxWidth, constraints.maxHeight);
        final small =
            Size(constraints.maxWidth * 0.68, constraints.maxHeight * 0.68);
        return _Ring(
            size: big,
            color: const Color(0xFFFEDED1).withOpacity(0.3),
            child: _Ring(
              size: small,
              color: const Color(0xFFFEDED1),
            ));
      },
    );
  }
}

class _Ring extends StatelessWidget {
  final Size size;
  final _Ring? child;
  final Color color;
  const _Ring({required this.size, required this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints:
          BoxConstraints.expand(width: size.width, height: size.height),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: child,
    );
  }
}
