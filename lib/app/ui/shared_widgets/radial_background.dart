import 'package:flutter/material.dart';

class RadialGradientBackground extends StatelessWidget {
  final Widget child;
  const RadialGradientBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.95, -0.95), // Aligns the gradient start
                radius: 1.0,
                colors: [
                  Color(0xFFD8E9F1),
                  Color(0xFFF3EAE0),
                  Color(0xFFF1F6F2),
                  Color(0xFFF6F6F6),
                ],
                stops: [0.2289, 0.5027, 0.7268, 1.0],
              ),
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
          border: Border.all(color: Colors.white, width: 1.2)),
      child: child,
    );
  }
}
