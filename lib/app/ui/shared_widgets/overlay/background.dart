part of 'overlay.dart';

class _OverlayBackground extends StatelessWidget {
  final Widget child;
  final bool absorbPointer;
  final Function()? close;
  const _OverlayBackground(
      {required this.absorbPointer, required this.child, this.close});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: absorbPointer,
      child: GestureDetector(
        onTap: close,
        child: Material(
          color: Colors.black12,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _OverlayDialogShape extends StatelessWidget {
  final Widget child;
  const _OverlayDialogShape({required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: IntrinsicHeight(
        child: Container(
          width: width,
          constraints: const BoxConstraints(maxHeight: 350),
          margin: EdgeInsets.symmetric(horizontal: width * 0.13),
          alignment: Alignment.center,
          child: Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 25),
                child: child,
              )),
        ),
      ),
    );
  }
}
