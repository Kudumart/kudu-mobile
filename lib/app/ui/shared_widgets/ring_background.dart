import 'package:flutter/material.dart';

class RingBackground extends StatelessWidget {
  final Widget child;
  const RingBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 248, 244, 239),
            ),
          ),
          const Center(
            child: _Rings(),
          ),
          Center(
            child: child,
          )
        ],
      ),
    );
  }
}

class _Rings extends StatelessWidget {
  const _Rings();

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.sizeOf(context).width;
    final biggerRingSize = Size(pageWidth, pageWidth);
    final bigRingSize = _circleSizeFrom(biggerRingSize, -150);
    final biggestRingSize = _circleSizeFrom(biggerRingSize, 150);

    return OverflowBox(
      maxHeight: biggestRingSize.height,
      maxWidth: biggestRingSize.width,
      child: _Ring(
        size: biggestRingSize,
        child: _Ring(
            size: biggerRingSize,
            child: _Ring(
              size: bigRingSize,
            )),
      ),
    );
  }

  Size _circleSizeFrom(Size size, double diff) {
    return Size(size.width + diff, size.height + diff);
  }
}

class _Ring extends StatelessWidget {
  final Size size;
  final _Ring? child;
  const _Ring({required this.size, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints:
          BoxConstraints.expand(width: size.width, height: size.height),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: const Color.fromARGB(255, 238, 234, 231), width: 1)),
      child: child,
    );
  }
}
